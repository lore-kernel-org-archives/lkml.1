Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYHUOi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYHUOi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbYHUOiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:38:19 -0400
Received: from il.qumranet.com ([212.179.150.194]:50355 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbYHUOiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:38:18 -0400
Message-ID: <48AD7DD9.9010506@qumranet.com>
Date: Thu, 21 Aug 2008 17:38:17 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM x86_emulate.c: duplicate SrcImm
References: <48AA20ED.9000705@gmail.com>
In-Reply-To: <48AA20ED.9000705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin wrote:
> Hi avi,
>
> you added this in commit 7d858a19efe5844a98e060931570359b70dea6d1
> any idea whether it should be replaced by something else?
> ---
> duplicate SrcImm
>   

Right.  Applied.

I don't know if some other bit is missing a SrcImm.  I'll review that code.


-- 
error compiling committee.c: too many arguments to function

