Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZCaJKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZCaJKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZCaJKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:10:32 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:13295 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZCaJKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kU1TLO84m6IYQQi59vGBFajLgI822waoFxd2HfvhkYuOIAw/BzLvKUFZsOnjLQgQsk
         ALfDhO9Gjk75Jh0JWb/mfSYGFmfkJD2+uSmT57aA/EMgadl+3j9keW0xikTuyPvStRZi
         EtBtyzxL9wJEETGXM9K7VXzhXxCCjH/F0/D+s=
Message-ID: <49D1DE00.9030600@gmail.com>
Date: Tue, 31 Mar 2009 18:10:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org> <49D0A985.7090307@panasas.com> <49D0FF56.3080205@kernel.org> <49D1D7A3.40303@panasas.com> <49D1DCE2.1050201@kernel.org>
In-Reply-To: <49D1DCE2.1050201@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really should proof read before hitting the send button.  My head is
somehow pretty good at messing up sentences.

Tejun Heo wrote:
> The reason why I want with sgl is because it's the sg mapping
                   went                    it has
...
> wouldn't be that large anyway.  Both aren't worth worrying about
> considering how relative coldness of the path and other overhead of

Eh.. that was a nice mix of "how the path is relatively cold" and
"relative coldness of the path".  :-)

Thanks.

-- 
tejun
