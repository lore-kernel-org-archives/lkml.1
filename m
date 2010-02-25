Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab0BYUYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:24:36 -0500
Received: from snt0-omc2-s32.snt0.hotmail.com ([65.55.90.107]:10623 "EHLO
	snt0-omc2-s32.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932792Ab0BYUYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:24:34 -0500
Message-ID: <SNT125-W652012E965D81A36E5533C3400@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>
CC: <luca@luca-barbieri.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 10/10] x86-32: panic on !CX8 && XMM
Date: Thu, 25 Feb 2010 12:24:33 -0800
Importance: Normal
In-Reply-To: <SNT125-W43CEC942D4248B42CA7B1DC3470@phx.gbl>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
 <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>,<4B7C6FC8.7090107@zytor.com>
 <SNT125-W19438E1E5A7FB2F02097DEC3480@phx.gbl>,<4B7C7EB3.6000202@zytor.com>,<SNT125-W43CEC942D4248B42CA7B1DC3470@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Feb 2010 20:24:33.0160 (UTC) FILETIME=[8A90C080:01CAB658]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> And in fact, the Linux setup code already has code similar to the code used in XP to disable this NT4 workaround.
Unfortunately, in virtual machines this often don't work:http://www.virtualbox.org/ticket/370http://www.virtualbox.org/ticket/774http://www.virtualbox.org/ticket/4874
Yuhong Bao 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with powerful SPAM protection.
http://clk.atdmt.com/GBL/go/201469227/direct/01/