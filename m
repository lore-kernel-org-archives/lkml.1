Return-Path: <linux-kernel-owner+w=401wt.eu-S965769AbXCLMQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965769AbXCLMQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 08:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965751AbXCLMQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 08:16:38 -0400
Received: from il.qumranet.com ([82.166.9.18]:43391 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965763AbXCLMQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 08:16:37 -0400
Message-ID: <45F544A2.6020100@qumranet.com>
Date: Mon, 12 Mar 2007 14:16:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Cong WANG <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Replace 0 with NULL when returning a pointer
References: <2375c9f90703112347r755bb59ehb17843c87f8e7353@mail.gmail.com>
In-Reply-To: <2375c9f90703112347r755bb59ehb17843c87f8e7353@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cong WANG wrote:
> Use NULL to indicate we are returning a pointer rather than an integer
> and to eliminate some sparse warnings.
>
> Signed-off-by: Cong WANG <xiyou.wangcong@gmail.com>

These are already fixed in my repo.


-- 
error compiling committee.c: too many arguments to function

