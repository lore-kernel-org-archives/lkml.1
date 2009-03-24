Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZCXSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZCXSqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZCXSqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:46:12 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48388 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbZCXSqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:46:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=Va7Q8FI6FNBwR3+dGYDsOeOlj+ELmWove3LsetzxWNO4TUB/ci78aRx34mRN9TtPat
         8GoENkhD0cnyqQ2AKVh9Su6UdoGlnqJ1Xn0qnFARsGAO1vsFNiW65DptvNthbq5x4uWv
         rkcZwr8xkaRT3nT6VIFrKvI0xpQmJ6R3vV/+0=
Message-ID: <49C92935.4090901@gmail.com>
Date: Tue, 24 Mar 2009 20:40:53 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: BUG in 2.6.29 final: broken network connection
References: <cjisi-2Kz-11@gated-at.bofh.it> <cjiC5-2XR-15@gated-at.bofh.it> <cjiVm-3mJ-23@gated-at.bofh.it>
In-Reply-To: <cjiVm-3mJ-23@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2009 07:50 PM, Eric Dumazet wrote:
> Alan Cox a écrit :
>> Wouldn't it have been simpler to wait when you found a problem and read
>> Ingo's email on the subject from a few hours ago ?
> 
> This guy had his life depending on linux-2.6.29 apparently, and failed
> to read netdev or lkml. Go figure...
> 
> It sounds like a troll, dont you think ?

Sounds like Uwe Bugla to me.

Niel

