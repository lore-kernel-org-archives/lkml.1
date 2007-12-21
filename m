Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbXLUPyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbXLUPyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXLUPyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:54:35 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39040 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbXLUPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:54:35 -0500
Date: Fri, 21 Dec 2007 10:54:34 -0500
To: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071221155434.GI2310@csclub.uwaterloo.ca>
References: <474E8669.6060409@cn.fujitsu.com> <200711291120.19595.elendil@planet.nl> <20071129032036.4c021617.akpm@linux-foundation.org> <474F6372.70705@cn.fujitsu.com> <1196386259.22120.101.camel@localhost> <474F6D4D.9010006@cn.fujitsu.com> <1196390128.22120.118.camel@localhost> <20071220162923.GB27885@shadowen.org> <20071220210741.6dc3caf5@the-village.bc.nu> <1198186984.6183.72.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198186984.6183.72.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 01:43:04PM -0800, Joe Perches wrote:
> Documentation/Coding Style
> 
> 		Chapter 13: Printing kernel messages
> 
> Kernel messages do not have to be terminated with a period.

'do not have to' does not mean 'should not'.  So the suggested patch
is wrong no matter what.

Prints of data and various tables would look silly with a period, but
sentences look better with it.

--
Len Sorensen
