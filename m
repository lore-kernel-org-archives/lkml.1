Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbXFVSG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbXFVSG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbXFVSGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:06:19 -0400
Received: from gw.goop.org ([64.81.55.164]:38902 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994AbXFVSGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:06:19 -0400
Message-ID: <467C0F71.4030607@goop.org>
Date: Fri, 22 Jun 2007 11:05:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Jesper Juhl <jesper.juhl@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
References: <20070620175737.GA6523@cvg> <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com> <467AC8E9.1000605@goop.org> <20070622155409.GA8283@cvg>
In-Reply-To: <20070622155409.GA8283@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Btw, Jeremy, could you please Ack it then and I'll resend the patch to Andrew ;)
>   

Not sure its worth a patch to just change that on its own.  Fix it in 
passing if it needs changing anyway, or generate a patch to fix them 
all.  But I can't see Andrew being very keen on churn for the sake of it.

    J

