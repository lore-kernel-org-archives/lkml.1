Return-Path: <linux-kernel-owner+w=401wt.eu-S936320AbXKPX1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936320AbXKPX1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935897AbXKPXUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:20:34 -0500
Received: from smtp21.orange.fr ([80.12.242.49]:23510 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935510AbXKPXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:20:31 -0500
X-ME-UUID: 20071116232027885.D84021C00089@mwinf2121.orange.fr
Subject: How to disable ECC with bootparam ?
From: Xavier Bestel <xavier.bestel@free.fr>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 17 Nov 2007 00:20:20 +0100
Message-Id: <1195255221.4408.7.camel@skapc.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have replaced my machine with another one which gives many ECC errors.
At first sight they may be pessimistic because memtest (with ECC off)
doesn't find anything (I'm letting run it overnight, I'll see tomorrow
morning if it really didn't find anything).
I'd like to let it run without thoses ECC messages (which slow it down
pretty much), but
- man bootparam doesn't say anything
- my git tree is on that machine, so I can't access it
- I couldn't successfully google for it

Thanks for your help,

	Xav


