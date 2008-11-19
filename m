Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYKSNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYKSNvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYKSNvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:51:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:59197 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYKSNvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Kc+AQrB7ZLugZPnuSBe8swiJvBWeRqiHFhz757D07sR7KrT94dBuK12sEnMmr69vSA
         g6EAGO/Duj+3R3YalejJoQzSXLspSHMlYNiCqzHJ1Psss4KD9iLHUvMHmcDETEi+LHBh
         s3YfePDdbxiX6cnssRRNvvAhjEdxksBVwLL7I=
Message-ID: <8bd0f97a0811190551r5f1a34f8u370caa225985e5c5@mail.gmail.com>
Date: Wed, 19 Nov 2008 08:51:02 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] Blackfin SMP like patchset
Cc: "Bryan Wu" <cooloney@kernel.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20081118225621.540416ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <20081118225621.540416ae.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 01:56, Andrew Morton wrote:
> On Tue, 18 Nov 2008 17:05:03 +0800 Bryan Wu wrote:
>> We provide the SMP like functions for our Blackfin dual core processor
>> BF561 for almost 1 year. And after a long time developing, debugging and
>> internal review, we'd like to post them to LKML for other maintainer
>> review.
>>
>> Please find our wiki page about this SMP like patches:
>> http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like
>
> Would prefer that changelogs be self-contained, please.  Kernel
> changelogs are for ever, and I doubt if that page will be there in 20
> years time.

that isnt a changelog though, it's documentation.  perhaps we should
put together a reduced version of the page for
Documentation/blackfin/smp-like.txt ...
-mike
