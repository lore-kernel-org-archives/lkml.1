Return-Path: <linux-kernel-owner+w=401wt.eu-S1762473AbXHFRLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473AbXHFRLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXHFRLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:11:30 -0400
Received: from jutra.pl ([195.117.212.254]:52669 "EHLO jutra.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbXHFRL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:11:29 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 13:11:28 EDT
From: Zbigniew <zibi@jutra.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] uvesafb: a general description
Date: Mon, 6 Aug 2007 19:04:55 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061904.55639.zibi@jutra.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I've already updated the patch on my website, so next time
>you download it, the error messages should be gone.

the latest uvesafb (rc3-2.6.22.patch)
 and v86d(0.1-rc4)  doesn't work against 2.6.22.1 ;(

dmesg:
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-3)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22

distr slackware 12 with my own kernel 2.6.22.1 (on 2.6.21.5 works fine)

lspci :
VGA compatible controller: nVidia Corporation NV11 [GeForce2 MX/MX 400] (rev 
b2) (prog-if 00 [VGA])


-- 
Pozdrawiam/Regards
Zibi K.
