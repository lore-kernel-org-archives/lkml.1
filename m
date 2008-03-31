Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbYCaElm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbYCaElm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 00:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYCaEle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 00:41:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:22082 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYCaEld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 00:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MPTlAkKEheMAsq8ysFAlgj/UmEU9WSb6yOXvmvFjiNEQh/sq0S7W+Y20oXzIghq/k629O9J8Tsx+5+jxGNDRde7o4O1hq1SBlMrNamW+OL1T2igO7CsfUEDPigW71Pax3mvnkm+v3uIxpoEm8CY2e0+q8j8LiG9OdX195FF6j/s=
Message-ID: <f284c33d0803302141x298d3785xcebabd28be65c0d0@mail.gmail.com>
Date: Mon, 31 Mar 2008 11:41:33 +0700
From: "Mulyadi Santosa" <mulyadi.santosa@gmail.com>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: blktrace debugging: how to use it
Cc: linux-kernel@vger.kernel.org,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
In-Reply-To: <47F0418C.8080407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F0418C.8080407@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi..

On Mon, Mar 31, 2008 at 8:42 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> The is patch is to enable blktrace debugging in the kernel:
>
>  http://lkml.org/lkml/2006/8/1/405
>
>  Can anyone provide any guidelines or references on how to use this
>  feature from userspace?   Any tools written to TEST and use this feature?

All I remember, the user space code is available from Jens Axboe's CVS
or http://www.kernel.org/pub/linux/kernel/people/axboe/tools/blktrace.c

regards,

Mulyadi
