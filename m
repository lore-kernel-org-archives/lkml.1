Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbZLKX1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbZLKX1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761722AbZLKX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:27:46 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49187 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471AbZLKX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JSQ/g4iwqXoigv9A5+a/7LXUr0qYIHVe7ycbJwljkNAXKwC9wweXfFUDoA2Oxbl2Jb
         +7c638x7EnYMdk2evXVikj6OiJAcHquu3cwkV2yoXRNZqvaVviKjz8yUIjf7Hr2SIpPC
         cVpHLDB7YAdUMBBq1121taxuh0ZJH2xoWOytw=
MIME-Version: 1.0
In-Reply-To: <21d7e9970912111526u5b7164eaydbea44986bb82d2e@mail.gmail.com>
References: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
	 <6a89f9d50912111523r178c0casb61fca1198f6f253@mail.gmail.com>
	 <21d7e9970912111526u5b7164eaydbea44986bb82d2e@mail.gmail.com>
Date: Sat, 12 Dec 2009 00:27:49 +0100
Message-ID: <6a89f9d50912111527y3ad430d5mce713b6ff38f9408@mail.gmail.com>
Subject: Re: [git pull] drm nouveau pony for Xmas.
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/12 Dave Airlie <airlied@gmail.com>:
> 2009/12/12 Stephane Marchesin <stephane.marchesin@gmail.com>:
> I did git log on the nouveau kernel tree nouveau dir with sort and uniq,
>
> I'm not sure where else I needed to trawl to get anymore ppl who have
> contributed to
> the KMS driver. I'm sure ppl contributed to X.org/Mesa drivers but
> this isn't the
> place for them. Also all copyright should be intact.
>

The problem is that when you moved from the drm to the linux tree, you
killed the whole history and the authors along.

> But we can add an author lists to the code subdir if you like, if
> someone compiles
> the complete list of ppl who have added code to the kernel driver.
>

That would indeed be the proper thing to do.

Stephane
