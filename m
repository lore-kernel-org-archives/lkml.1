Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZHOHHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZHOHHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 03:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZHOHHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 03:07:49 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44349 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZHOHHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 03:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C8qD01aNNeGizIJVbBAKSz0d1Ooz48cyVNgBi+P/1Fjzbb4dml2TVh4XAVi2QTe+g1
         q2ff98E5kW5ZTtB2utK1Z0LW76VUuq82kZzuTHLfqCNAqnZkhlKkvzTlUV9iH3+MIb7x
         cy0v/6sl98hqhp+q1wSonR4qx5PXpMA/ZORjw=
MIME-Version: 1.0
In-Reply-To: <4A85D23D.7030809@t-online.de>
References: <4A853ED8.9030800@t-online.de> <1250250242.5241.1395.camel@twins>
	 <4A856B13.90202@t-online.de>
	 <b637ec0b0908140701r1d35e8daj15d47a246e865db8@mail.gmail.com>
	 <4A85D23D.7030809@t-online.de>
Date: Sat, 15 Aug 2009 09:07:48 +0200
Message-ID: <b637ec0b0908150007k15accc5exb807783b828661fa@mail.gmail.com>
Subject: Re: drm / i915 performance problems
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Peter Zijlstra <peterz@infradead.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
My config is:

* X.org v. 1.6.3
* intel driver v. 2.7.99.902 (2.8-pre)
* intel-dri v.7.5
* mesa v. 7.5
* kernel v.2.6.31-rc6 with KMS

on an eeePC 900 with very good performance. Userspace is now ArchLinux.

Regards,
Fabio




On Fri, Aug 14, 2009 at 11:08 PM, Knut
Petersen<Knut_Petersen@t-online.de> wrote:
> Fabio Comolli schrieb:
>>
>> If I remember correctly the solution was to add this repository:
>>
>>     http://download.opensuse.org/repositories/X11:/XOrg/openSUSE_11.1/
>>
>> to the repository list and then perform an update. Sorry but I left
>> Opensuse some months ago and my memory isn't helping a lot...
>>
>> Hope this helps. Regards,
>> Fabio
>>
>>
> No, it does not help too much. I  updated to the  software provided there
> and the result is a X  server that crashes during startup ... :-(
>
> Which X server is supposed to work with 2.6.30 (++) kernels on i915GM
> hardware?
>
> cu,
>  Knut
>
