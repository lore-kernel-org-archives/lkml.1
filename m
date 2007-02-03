Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbXBCWJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbXBCWJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 17:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXBCWJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 17:09:01 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53269 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751638AbXBCWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 17:09:00 -0500
Date: Sat, 3 Feb 2007 22:21:41 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ban module license tag string termination trick
Message-ID: <20070203222141.6f723fd9@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.61.0702032136430.13874@yvahk01.tjqt.qr>
References: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>
	<Pine.LNX.4.61.0702032136430.13874@yvahk01.tjqt.qr>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 21:47:36 +0100 (MET)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Feb 3 2007 10:31, David Schwartz wrote:
> >
> >The way out of the GPL problem is to make clear that it is *not* a 
> >copyright enforcement scheme
> 
> So why do we have EXPORT_SYMBOL_GPL then, if

Because if you go around modifying code to get around it then regardless
of the DMCA question you are actively doing it and there is very clear
intent to do other than the right holder intended. In some ways its the
difference between walking through an open archway into a private area
and kicking the door down to get in.
