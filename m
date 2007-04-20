Return-Path: <linux-kernel-owner+w=401wt.eu-S1767165AbXDTRsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767165AbXDTRsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767168AbXDTRsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:48:00 -0400
Received: from mx02.qsc.de ([213.148.130.14]:34803 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767165AbXDTRr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:47:58 -0400
X-Greylist: delayed 1471 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 13:47:58 EDT
From: =?iso-8859-1?q?Ren=E9_Rebe?= <rene@exactcode.de>
Organization: ExactCODE
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: InitIO SCSI: Volunteers required
Date: Fri, 20 Apr 2007 19:23:16 +0200
User-Agent: KMail/1.9.6
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070420103849.7358f1f1@the-village.bc.nu>
In-Reply-To: <20070420103849.7358f1f1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704201923.16996.rene@exactcode.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: Spam detection software, running on the system "grum.localhost", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Friday 20 April 2007 11:38:49 Alan Cox wrote: > I'm
	looking for some testers for a revamp of the initio driver. No real >
	code changes other than to hopefully stop it exploding on load on 64bit,
	> but a major reorganisation, commenting and "de-windowsification" so
	the > code is actually readable and I can do the pci_find_device to >
	pci_get_device transitions. [...] 
	Content analysis details:   (-1.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 11:38:49 Alan Cox wrote:
> I'm looking for some testers for a revamp of the initio driver. No real
> code changes other than to hopefully stop it exploding on load on 64bit,
> but a major reorganisation, commenting and "de-windowsification" so the
> code is actually readable and I can do the pci_find_device to
> pci_get_device transitions.

I once had  such a card flying around, feel free to attach it to me
and I can see if I find the card in some box over the weekend :-)

Yours,

-- 
  René Rebe - ExactCODE GmbH - Europe, Germany, Berlin
  Geschäftsführer: Susanne Klaus, René Rebe
  Sitz: Berlin, Amtsgericht Charlottenburg HRB 105 123 B
  USt-IdNr.: DE251602478
  http://exactcode.de | http://t2-project.org | http://rene.rebe.name
