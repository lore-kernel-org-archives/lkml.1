Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYBOT2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYBOT2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYBOT2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:28:39 -0500
Received: from chudak.whitesoft.cz ([81.92.149.98]:46683 "EHLO
	chudak.whitesoft.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYBOT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:28:39 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 14:28:38 EST
Message-ID: <47B5E61F.3030603@century.cz>
Date: Fri, 15 Feb 2008 20:21:03 +0100
From: =?ISO-8859-2?Q?Petr_Tit=ECra?= <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: e_powersaver.c
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

    is there some reason for printing current voltage and multiplier of 
processor after each change? This change was added by commit 553ae38c. 
If this required for some reason can be this output changed to use 
KERN_DEBUG level?


Petr Titera
