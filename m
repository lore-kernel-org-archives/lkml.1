Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZBXGy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZBXGy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZBXGyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:54:18 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:38630 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZBXGyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eafoiGkCrOMeQih7PSVqQP1Jkm8/P8sS/kTrbqrfYh/vwZ4/PP6Nop2UC3n3r2+sm6
         0vrcer5E7m4etwAKdAKqZ9AQ75JZfOZ2m1nGipEJXn1V2zKbz6mvMd2fnr+AK1js8OaD
         ATIH4MUj1vH2Ji37l0GrCsgtvKST7/a6eUZx4=
MIME-Version: 1.0
In-Reply-To: <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
	 <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>
	 <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
	 <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
Date: Tue, 24 Feb 2009 07:54:14 +0100
Message-ID: <8db1092f0902232254q10826fei8b8125b3da5f233@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not 
	ioremap virtual address for G33 hw status page
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/24 Yinghai Lu <yinghai@kernel.org>:

>
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>
> should help mtrr ones.
>
> please post bootlog with those option set.
>
> YH
>

It doesn't help, see previous mails.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
