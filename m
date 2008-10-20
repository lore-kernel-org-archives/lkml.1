Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYJTKNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYJTKNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJTKNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:13:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:27443 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYJTKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V2qUtG0EAArvhQCqzdhvCVlBl1xoeb5nrdHLHJRq71kuDVfwWsA4WokbsqvuizN2uJ
         pcRqhLQ8a2ebtBlFijWPFyJyOUzbZfRnqT7irbomNBYN31g+t+jxBvCsGXotsvx/qioO
         xxUzmp+l2XsgRTtIfiz0lMqSEkee/Hj34bIds=
Message-ID: <2891419e0810200313j5cac8541qff80614e3d784b1b@mail.gmail.com>
Date: Mon, 20 Oct 2008 19:13:14 +0900
From: "Dong-Jae Kang" <baramsori72@gmail.com>
To: "Ryo Tsuruta" <ryov@valinux.co.jp>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0: Introduction
Cc: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       corsetproject@googlegroups.com
In-Reply-To: <20081020.180129.193689104.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	 <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
	 <20081020.180129.193689104.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ryo Tsuruta

Thank you for fast reply.

2008/10/20 Ryo Tsuruta <ryov@valinux.co.jp>:
> Hi Dong-Jae,
>
>> I am trying to install your new released dm-ioband v1.8.0
>> I/O bandwidth controller v1.8.0 could be adjusted to  the latest
>> stable kernel 2.6.27.1
>> it was good news for me
>> but, I had a problem when I try to patch bio-cgroup files to  stable
>> kernel 2.6.27.1
>> many patch failure and hunk messages were occured.
>>
>> Can you check bio-cgroup patch files against stable kernel 2.6.27.1?
>
> bio-cgroup patch can apply only to 2.6.27-rc5-mm1 so far.
> Please use 2.6.27-rc5-mm1 to try both bio-cgroup and dm-ioband,
> dm-ioband v1.8.0 can also apply to 2.6.27-rc5-mm1.

OK, I will use kernel-2.6.27-rc5-mm1 as your comments

Well, do you have any plan to upgrade bio-cgroup patches for stable
latest kernel?
but, I think it will be not easy job ^^
Thank you

Regards,
Dong-Jae Kang


-- 
-------------------------------------------------------------------------------------------------
   DONG-JAE, KANG
   Senior Member of Engineering Staff
   Internet Platform Research Dept, S/W Content Research Lab
   Electronics and Telecommunications Research Institute(ETRI)
   138 Gajeongno, Yuseong-gu, Daejeon, 305-700 KOREA
   Phone : 82-42-860-1561 Fax : 82-42-860-6699
   Mobile : 82-10-9919-2353 E-mail : djkang@etri.re.kr (MSN)
-------------------------------------------------------------------------------------------------
