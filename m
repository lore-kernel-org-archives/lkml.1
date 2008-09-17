Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYIQIUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYIQIUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYIQITz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:19:55 -0400
Received: from ag-out-0708.google.com ([72.14.246.242]:40926 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYIQITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nwk8eo9ypcSoU54ruA9mmuTgQVkDoa577r2Ok7vmxldqRf9T1JJjUTs/IkFsvkptz4
         hnSmujqMMHdjq+9I5RdZx6vEO+kj2vw7zwIfZrXMFAu1c+wNWELp99i5iA6A1ieHOrWY
         BvDxbISo5X1n17KRQZIv4jD025v6+oispJPTQ=
Message-ID: <25136850809170119p2ea954ek6ece0c847dfa5823@mail.gmail.com>
Date: Wed, 17 Sep 2008 13:49:53 +0530
From: "mal reddy y" <malreddy.linux@gmail.com>
To: Bily <hsssss1111@163.com>
Subject: Re: insmod problem
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200809161515454846111@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809161515454846111@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

give clear explanation how you have installed

regards,
YMR

On Tue, Sep 16, 2008 at 12:45 PM, Bily <hsssss1111@163.com> wrote:
> hi,all;
>    I want to insert an module:yaffs.ko into my kernel2.6.26,but i meet this question:
>
> [\u@\h \W]$insmod yaffs.ko
> yaffs: unknown relocation: 40
> insmod: cannot insert 'yaffs.ko': invalid module format
>
> and my busybox version is v1.11.1; may anyone tell me why ?thanks!
>
>
> Bily
> 2008-09-13
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
