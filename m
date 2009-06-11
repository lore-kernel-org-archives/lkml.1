Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbZFKAyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbZFKAyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZFKAyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:54:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:39294 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbZFKAyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b4GWkxbzFsf5CBjSY7QHxtYxMk3LQNGp0is4p/ixNwrjWPVn5l+xO0FrCAnaMAKFlg
         x9a4efknbgdoFQxhm0bhfSGrsjneGMuc/uDnj17pTggWPDcDoIlR3oNE6zF6ms9KgC71
         C0ixvl70s0v1un979B6IaPkmYvjjjL38vOh6o=
MIME-Version: 1.0
In-Reply-To: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com>
References: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com>
Date: Wed, 10 Jun 2009 17:54:39 -0700
Message-ID: <86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com>
Subject: Re: Macbook 4G only see 3G
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 5:47 PM, Trenton D.
Adams<trenton.d.adams@gmail.com> wrote:
> Hi Guys,
>
> Has anyone been doing any development in the area of enabling 4G for
> any PC that doesn't have an option in the BIOS?  The Mac OS X sees the
> full 4G, but Linux does not.
>
> tdamac ~ # uname -a
> Linux tdamac 2.6.30-rc7-dirty #3 SMP Fri Jun 5 21:24:29 MDT 2009
> x86_64 Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux

boot log?

YH
