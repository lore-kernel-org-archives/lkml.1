Return-Path: <linux-kernel-owner+w=401wt.eu-S934469AbZKYD6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbZKYD6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934279AbZKYD6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:58:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35429 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246AbZKYD6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:58:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bZ7+ypbP1maZRqMi38vlXHY1NSlFVGLK42oepS4dgKj21ULELhlsXhVITLH7mEDdc+
         9LQ1PWugFn4sAtGpDtPbakbEgTNoDJo9uenVfiM6Pkwfgaw47i2eiLazhcAslEHz1nb4
         jzCIP+Cs2FIiDIfrZjMRtpb7zRcgGJSJDSWvo=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0911241951o5394972dl65c48371f4149b7d@mail.gmail.com>
References: <1259148311-31724-1-git-send-email-cliffcai.sh@gmail.com>
	 <8bd0f97a0911241951o5394972dl65c48371f4149b7d@mail.gmail.com>
Date: Wed, 25 Nov 2009 11:58:40 +0800
Message-ID: <da1989290911241958o88d49a8i14a2c9b39f1f101b@mail.gmail.com>
Subject: Re: [PATCH v2] [mmc/host]:Blackfin SD Host Controller Driver
From: Cliff Cai <cliffcai.sh@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       cliff.cai@analog.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 11:51 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Nov 25, 2009 at 06:25,  <cliffcai.sh@gmail.com> wrote:
>> From: Cliff Cai <cliffcai.sh@gmail.com>
>>
>> v2-v1 change:remove mmc host before releasing it in sdh_probe().
>>
>> Signed-off-by: Cliff Cai <cliffcai.sh@gmail.com>
>> ---
>
> changelog info should be below the ---, not above.

is this true?

> you're also missing the s-o-b's:
>    Signed-off-by: Bryan Wu <cooloney@kernel.org>
>    Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> -mike
>

Ok,I will do it.

Cliff
