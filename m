Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZGOJKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZGOJKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZGOJKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:10:51 -0400
Received: from relay8.kornet.net ([211.48.62.136]:45381 "EHLO
	relay8.kornet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZGOJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:10:50 -0400
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 05:10:50 EDT
Message-ID: <4A5D9A33.5080601@gmail.com>
Date: Wed, 15 Jul 2009 17:58:27 +0900
From: "J.Hwan.Kim" <frog1120@gmail.com>
Reply-To: frog1120@gmail.com
User-Agent: IceDove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: question about ARM9 SMDK2440 ethernet driver
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
X-TERRACE-SPAMMARK: NO       (SR:9.41)                     
  (by Terrace)                                                   
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone

I have a question about the ethernet driver of SMDK2440(ARM920T) board.
The ethernet device in the SMDK2440 schematic from SAMSUNG is CS8900.
However, the ethernet driver of SMDK2440 in kernel 2.6.26 is DM9000.

Is there any reason why kernel 2.6.26 is written for DM9000, not CS8900?

Thanks in advance.

Regards,
J.Hwan Kim



