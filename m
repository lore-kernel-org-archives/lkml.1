Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYGHI3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYGHI3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYGHI3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:29:25 -0400
Received: from mxsec.euro-web.fr ([81.93.243.199]:40968 "EHLO
	mxsec.euro-web.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYGHI3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:29:24 -0400
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: linux-kernel@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: weird bug on r8169 with usb
Date: Tue, 8 Jul 2008 10:29:21 +0200
User-Agent: KMail/1.9.7
Cc: Kasper Sandberg <lkml@metanurb.dk>
References: <200806250018.37617.david.ml@euro-web.fr>
In-Reply-To: <200806250018.37617.david.ml@euro-web.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807081029.21727.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 25 June 2008 00:18:37 David CHANIAL, vous avez écrit :
> If i boot my system/kernel with usb devices plugged, eth0 is detected but
> unusable. I unplug the usb devices, kernel boot, and eth0 is usable.
> The bug is reproducible as much as necessary.

Hi Francois,

Since i have updated to 2.6.25.10 it seems to be solved.
I will alert you if the "bug" reappear.

I think one of the update between 2.6.25.5 and 2.6.25.10 solve the problem.

$ uname -a
Linux cigalons 2.6.25.10 #1 SMP PREEMPT Mon Jul 7 17:33:26 CEST 2008 i686 
Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel GNU/Linux

Best regards,
-- 
David CHANIAL
