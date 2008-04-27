Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYD0DJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYD0DJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 23:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYD0DI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 23:08:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44688 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYD0DI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 23:08:59 -0400
Date: Sun, 27 Apr 2008 05:08:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Colored Kernel Output for 2.6.25
Message-ID: <alpine.LNX.1.10.0804270450031.20150@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This is CKO rediffed for 2.6.25. It is advised (but should not be 
mandatory) to slurp in "vt: fix background color on line feed" first as 
I removed the linefeed-color hack from CKO since the lf thing really 
is a separate issue that also happens outside CKO.
Nothing new really, as usual you can give any of the 8 kernel logging 
levels a color from the 16-color palette. Of course it all defaults to 
the defaults you have seen in the past 10+ years, so no worries.

If anybody wants to apply it, the better.
