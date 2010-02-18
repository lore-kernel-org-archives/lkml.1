Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0BRTpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:45:49 -0500
Received: from snt0-omc2-s7.snt0.hotmail.com ([65.55.90.82]:52914 "EHLO
	snt0-omc2-s7.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360Ab0BRTps convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:45:48 -0500
Message-ID: <SNT125-W40D001F6B983BB840DE140C3470@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <luca@luca-barbieri.com>
CC: <andi@firstfloor.org>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
Date: Thu, 18 Feb 2010 11:45:47 -0800
Importance: Normal
In-Reply-To: <4B7D8FA5.40901@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
	 <20100218101156.GE5964@basil.fritz,<4B7D8FA5.40901@zytor.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Feb 2010 19:45:47.0734 (UTC) FILETIME=[F79CA760:01CAB0D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> We don't care about 486 SMP. 
Yep, I remember when a previous patch broke 486 SMP support and since then, seemed like nobody cared.The closest to such a system I have seen was P5 systems using the 82489DX APIC.Anybody have a dmesg of such a system?
Yuhong Bao 		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
http://clk.atdmt.com/GBL/go/201469230/direct/01/