Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZBPX0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZBPX0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZBPX0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:26:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34629 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZBPX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:26:22 -0500
Date: Mon, 16 Feb 2009 23:26:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216232619.GB15678@srcf.ucam.org>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz> <20090216231324.GA15435@srcf.ucam.org> <20090216232259.GK1370@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216232259.GK1370@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:22:59AM +0100, Pavel Machek wrote:
> On Mon 2009-02-16 23:13:24, Matthew Garrett wrote:
> > Meanwhile, on embedded it's becoming a less interesting problem because 
> > idle and suspended are often now equivalent states. 
> 
> Android people tell us otherwise.

https://lists.linux-foundation.org/pipermail/linux-pm/2009-January/019493.html 
says that they're the same on their current platform.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
