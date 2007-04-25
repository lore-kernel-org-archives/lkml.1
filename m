Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXDYORd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXDYORd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbXDYORd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:17:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:3552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbXDYORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JNGumoV/qKJZ+40VpU4673ngbOYsiMyAogWXnabtWKP/3tOtynIJQXja/tB3oglhRDk6hIDAJ5I83HnspORuqwwheL+BMk4TEpI90CEd/iJBKlOyBtEiFb68Jilt2LdeL6hBBfGpJZVq2SHUfys3WFOnlfoqwuhoFimnMd1wriA=
Message-ID: <3877989d0704250717t99a0b22rd304e714d9a96620@mail.gmail.com>
Date: Wed, 25 Apr 2007 22:17:30 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Brown, Len" <len.brown@intel.com>
Subject: Re: drivers/video/output.c
Cc: "Dave Jones" <davej@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Yu, Luming" <luming.yu@intel.com>, adaplas@pol.net, greg@kroah.com
In-Reply-To: <CFF307C98FEABE47A452B27C06B85BB602F4BDC9@hdsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417213716.GB7284@redhat.com>
	 <CFF307C98FEABE47A452B27C06B85BB602F4BDC9@hdsmsx411.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The user of output sysfs class is coming..
Please check out the acpi video_output patch I just sent to acpi mailing list.
I can't post link here, just because It is not in archive of the ml yet..

On 4/18/07, Brown, Len <len.brown@intel.com> wrote:
> >Asides from git-bisect failing me again[1], what gives with this file?
>
> it supports output switching, which didn't make it into 2.6.21 --
> probably will be 2.6.22.
>
> -Len
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
