Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbZDSQkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbZDSQkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbZDSQko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:40:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:46979 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbZDSQko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:40:44 -0400
Cc: Linuxppc-dev Development <linuxppc-dev@ozlabs.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Message-Id: <2B3EB2F4-7F33-4243-B39D-F9331D3E08D6@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: derekzheng <zhengxiang9@163.com>
In-Reply-To: <003001c9c0d0$c6919510$53b4bf30$@com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: who know's what is "TestFloat cases" and how to test this feature on the Freescale MPC8536DS board
Date: Sun, 19 Apr 2009 11:40:29 -0500
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>	<74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu>	<20090417170707.B6C95C4004F@mail150-wa4.bigfish.com> <fa686aa40904172249m5e261492w48c8d9d8446600e0@mail.gmail.com> <003001c9c0d0$c6919510$53b4bf30$@com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 19, 2009, at 4:25 AM, derekzheng wrote:

> Hi all guys:
>
> The Freescale MPC8536DS board Integrated TestFloat cases, and I do  
> not know how to test this feature on this board.
> Please tell me how to test it if you known

1. why are you CC' the microblaze list on this question?
2. I assume you are talking about the FSL BSP for MPC8536DS
3. testfloat is a set of tests.  Its not clear what your question is.   
You build testfloat and run it and it reports pass/fails.

- k
