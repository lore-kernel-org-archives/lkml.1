Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbXE2AuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbXE2AuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 20:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXE2AuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 20:50:00 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:36474 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbXE2AuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 20:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AnZ41B2g/RbTsIudJaH1/P82G1uljINdzTMnjyerx7qpZHZvtjdUKUoLN829XN+K9YBjTGbFh5deyrU07bgYGWJ1U7mpOzbGRTpBXIa+G59qmKgwzRDxKfODv6LDFznJ1Uwpni7DrUINiCig8mUsOedhC0m/VFr4ol/Ikd24SAU=
Message-ID: <465B78AC.4050009@gmail.com>
Date: Tue, 29 May 2007 08:49:48 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <465A2DA4.7070409@gmail.com>
In-Reply-To: <465A2DA4.7070409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Li Yu wrote:
>
> But as I observe by cat /proc/sched_debug (2.6.21.1, UP, RHEL4), I 
> found the all waiting fields often are more than zero, or less than zero.
>
> IMHO, the sum of task_struct->wait_runtime just is the denominator of 
> all runnable time in some ways, is it right? if so, increasing the sum 
> of wait_runtime just make scheduling decision more precise. so what's 
> meaning for keeping the wait_runtime is zero-sum?
>
Forget it pls, here I am wrong, sorry for pestering.

Good luck

- Li Yu

