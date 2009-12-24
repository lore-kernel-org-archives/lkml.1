Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZLXMBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZLXMBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZLXMBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:01:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56048 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZLXMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:01:07 -0500
Date: Thu, 24 Dec 2009 04:01:04 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: CoolCold <coolthecold@gmail.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28.10 - kernel BUG at mm/rmap.c:725
In-Reply-To: <f19d625d0912240309g5c066de7pc4dc9d95c084d4df@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0912240356070.3483@bogon.housecafe.de>
References: <f19d625d0912240309g5c066de7pc4dc9d95c084d4df@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+gyrACt3phoLwmgFxMC/TSJvc9VSGedm8Me38
 JRZVgbFnZ4idRqV8lmvvv0oAThEGBxrxLGhqxq3sl1sKFC0ggp
 x/8V3I4e1wCYCpMzhhWxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Dec 2009 at 14:09, CoolCold wrote:
> 3 days ago LA on server become very high

Was the higher load caused by "real" work, i.e. were there more processes 
running than usual or did the load increase "just so"?

> bug - kernel BUG at mm/rmap.c:725! . Googling didn't provide me with
> exact answer is it bug or hardware problems, something similar was

Did you check for hardware problems? Running memtest for a day would be a 
good start, I think. If the load did increase "just so" and the machine 
(and the same kernel) were stable before, it's most likely hardware 
related.

Christian.
-- 
BOFH excuse #102:

Power company testing new voltage spike (creation) equipment
