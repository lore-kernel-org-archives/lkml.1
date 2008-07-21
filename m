Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYGUJgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYGUJgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYGUJgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:36:24 -0400
Received: from il.qumranet.com ([212.179.150.194]:25042 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbYGUJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:36:23 -0400
Message-ID: <48845896.6020500@qumranet.com>
Date: Mon, 21 Jul 2008 12:36:22 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] KVM: fix exception entry / build bug, on 64-bit
References: <1216554241-9966-1-git-send-email-avi@qumranet.com> <20080721090946.GA3795@elte.hu>
In-Reply-To: <20080721090946.GA3795@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hi Avi,
>
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>       KVM: Handle virtualization instruction #UD faults during reboot
>>     
>
> -tip testing found a build failure on 64-bit x86, caused by this commit. 
> Find the fix below.
>
>   

Thanks.  Applied this and will push to Linus later on.

-- 
error compiling committee.c: too many arguments to function

