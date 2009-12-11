Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbZLKXtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbZLKXtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761650AbZLKXtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:49:18 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55727 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761571AbZLKXtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:49:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hA252PnVrL+cOfMleq7UP+FRA3aA3QbxVHhxRmwTdnngsWihaHiaXSk8L1Wvn6H6pv
         q04jpbCWJBN2WP1wRhRlceO39kvZvbIjXXaVutg+i889ZhK4+zTUkdC5vobKuTjS5dhY
         jby/GtHb9K8qWaAStlCHxPZtKvjh8QSPwUSJc=
MIME-Version: 1.0
In-Reply-To: <6a89f9d50912111527y3ad430d5mce713b6ff38f9408@mail.gmail.com>
References: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
	 <6a89f9d50912111523r178c0casb61fca1198f6f253@mail.gmail.com>
	 <21d7e9970912111526u5b7164eaydbea44986bb82d2e@mail.gmail.com>
	 <6a89f9d50912111527y3ad430d5mce713b6ff38f9408@mail.gmail.com>
Date: Sat, 12 Dec 2009 00:49:22 +0100
Message-ID: <6a89f9d50912111549i5885480xe7564ace8142a275@mail.gmail.com>
Subject: Re: [git pull] drm nouveau pony for Xmas.
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 00:27, Stephane Marchesin
<stephane.marchesin@gmail.com> wrote:
> 2009/12/12 Dave Airlie <airlied@gmail.com>:
>> 2009/12/12 Stephane Marchesin <stephane.marchesin@gmail.com>:
>> I did git log on the nouveau kernel tree nouveau dir with sort and uniq,
>>
>> I'm not sure where else I needed to trawl to get anymore ppl who have
>> contributed to
>> the KMS driver. I'm sure ppl contributed to X.org/Mesa drivers but
>> this isn't the
>> place for them. Also all copyright should be intact.
>>
>
> The problem is that when you moved from the drm to the linux tree, you
> killed the whole history and the authors along.
>
>> But we can add an author lists to the code subdir if you like, if
>> someone compiles
>> the complete list of ppl who have added code to the kernel driver.
>>
>
> That would indeed be the proper thing to do.
>

Ok, as you requested here is a proper list of actual authors:

Arthur Huillet <arthur.huillet@free.fr>
Anssi Hannula <anssi.hannula@iki.fi>
Ben Skeggs <bskeggs@redhat.com>
B. Rathmann <koala_br@users.sourceforge.net>
Danny Tholen <moondrake@gmail.com>
Dave Airlie <airlied@redhat.com>
Francisco Jerez <currojerez@riseup.net>
Jeremy Kolb <jkolb@brandeis.edu>
Maarten Maathuis <madman2003@gmail.com>
Marcin Kościelnicki <koriakin@0x04.net>
Matthew Garrett <mjg@redhat.com>
Matthieu Castet <castet.matthieu@free.fr>
Matt Parnell <mparnell@gmail.com>
Maurice van der Pot <griffon26@kfk4ever.com>
Patrice Mandin <patmandin@gmail.com>
Pekka Paalanen <pq@iki.fi>
Stephane Marchesin <marchesin@icps.u-strasbg.fr>
Stuart Bennett <stuart@freedesktop.org>
Xavier Chantry <shiningxc@gmail.com>

As far as I can recall, this list is complete.

Stephane
