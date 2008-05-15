Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbYEOULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbYEOULn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYEOULd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:11:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbYEOULc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:11:32 -0400
Date: Thu, 15 May 2008 13:07:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 22/37] x86: sysfs cpu?/topology is empty in 2.6.25
	(32-bit Intel system)
Message-ID: <20080515200751.GA24902@suse.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201222.GW31167@suse.de> <20080515180643.GD6787@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515180643.GD6787@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 11:36:43PM +0530, Vaidyanathan Srinivasan wrote:
> * Greg KH <gregkh@suse.de> [2008-05-13 13:12:22]:
> 
> > 2.6.25-stable review patch.  If anyone has any objections, please let us
> > know.
> 
> Hi Greg,
> 
> This fix has been included in 2.6.26-rc2 and has been tested for
> correct topology information in the following system configurations:
> 
> 32-bit Two socket dual core xeon 5160 processor system
> 32-bit Two socket quad core xeon E5450 processor system
> 
> Tested-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

Thanks for the testing, sorry I didn't get to add you to the changelog,
I got your response after I did the release :(

greg k-h
