Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbXFUQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbXFUQ3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXFUQ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:29:19 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:48142 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768AbXFUQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:29:18 -0400
Date: Thu, 21 Jun 2007 18:29:17 +0200
From: Alexander Wuerstlein <arw@arw.name>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signed binaries support [0/4]
Message-ID: <20070621162917.GB9741@cip.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de> <20070621161758.GP12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621161758.GP12950@stusta.de>
X-Echelon-Scan: plutonium bomb dirty irak allah satan bush victory c4
	cocaine saddam wtc holy war believe god cia nsa
X-Echelon-Result: Terrorist
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 070621 18:19, Adrian Bunk <bunk@stusta.de> wrote:
> On Thu, Jun 21, 2007 at 05:55:16PM +0200, Johannes Schlumberger wrote:
> 
> > Hi,
> 
> Hi Johannes,
> 
> > We (two students of CS) built a system for signing binaries and verifying them
> > before executing. Our main focus was to implement a way to inhibit execution
> > of suid-binaries, which are not trustworthy (i.e. not signed).
> >...
> 
> doesn't anyone who is able to install a not trustworthy suid-binary 
> already have the priviliges to do anything he wants to without requiring 
> an suid bit?

Yes, quite correct in most cases. But if you have taken control of a computer
on of the more common ways to keep the control for some time is the
installation of a suid-binary (e.g. as part of a rootkit). 

One could also imagine a scenario where an attacker controls some filesystems
(on external storage perhaps) where he can of course manipulate the suid bit,
but he does not have direct control over the attacked system unless he can
execute that file.



Ciao,

Alexander Wuerstlein.
