Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYACQS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYACQS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYACQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:18:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:48314 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYACQSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:18:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BmMXUToXsGZmj61YTS/5x0lb4vD1CwZg/OlcImnpa1oj+TOcQMUxqB0MJnkTo69D/qeykIPICE4qQhWBStsg+dXCRjqsKLbZrIv5jX8KyRb7Pf/YKqyp4IwzMDjR3R1BZ7TT0d/PTUOnO8rGp3ScSwvSySP9avSBfYljs4zf0n4=
Message-ID: <d120d5000801030818h71e1d6a4obfb99352ff3a513@mail.gmail.com>
Date: Thu, 3 Jan 2008 11:18:45 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] gameport: unexport static inline functions (alpha build fix)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071227113204.GA22678@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071227113204.GA22678@jurassic.park.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 27, 2007 6:32 AM, Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> These two are defined inline in linux/gameport.h.
>
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Applied to my tree - for-linus branch. Thank you Ivan.

-- 
Dmitry
