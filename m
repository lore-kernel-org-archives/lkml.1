Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZGWLPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZGWLPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZGWLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:15:45 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:52592 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZGWLPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KiOzDjAsbhOe9/VGze8INiLBhOAT5g963MISOuOJffb5BUqC/hiBlpoFjvruhItd2l
         zru22vLRqTbcJa0nmrJgTs8jI+EjP9fVie8FLvNuwxXiFoRk6PlszVGA/eR9kuK11nxF
         DnfgPyOsWevzzy0Sdwoq2SXNVtfctgv58eCRo=
MIME-Version: 1.0
In-Reply-To: <200907241241.42842.bzolnier@gmail.com>
References: <200907031516.51893.bzolnier@gmail.com>
	 <1248322878-3804-1-git-send-email-donari75@gmail.com>
	 <200907241241.42842.bzolnier@gmail.com>
Date: Thu, 23 Jul 2009 20:15:45 +0900
Message-ID: <57afda040907230415x4e07d984jb34d14ab34df06db@mail.gmail.com>
Subject: Re: [PATCH] mg_disk: Add missing ready status check on mg_write()
From: unsik Kim <donari75@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> [ It is on top of my patch (http://lkml.org/lkml/2009/6/28/237), right?
>
Right. I missed the comments for your previous patch.
>  I assume that both patches were verified with hardware and are ready
>  to be merged upstream now? ]
>
Yes, tested. :)

---
Regards,
unsik Kim <donari75@gmail.com>
