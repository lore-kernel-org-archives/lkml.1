Return-Path: <linux-kernel-owner+w=401wt.eu-S965734AbXAYJR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965734AbXAYJR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965731AbXAYJR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:17:29 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:5225 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965734AbXAYJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:17:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eeuBYb2w2+ZhyHOSeIMm/tc3X4gfNKJZCrw7cYwu0kVyPoJu/WsOC+BntvWfBf6dcLiGBQrr8k4/Wp1ESddEsy4QQS4/y1tukGZufJauEQ8NGJKcvmBXXA6gPAV9DuHeksHaywdLmtjDDxPjMgaQQq6zc1PWgZZoN78ztrX+6dQ=
Message-ID: <3877989d0701250117j29c04687rbb8214ed5bbb2bbd@mail.gmail.com>
Date: Thu, 25 Jan 2007 17:17:27 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Eamonn Hamilton" <EAMONN.HAMILTON@saic.com>
Subject: Re: IO-APIC + timer doesn't work - 2.6.20-rc5 on abit KN9-Ultra b ios 1.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1169715782.22508.202.camel@ukabzc383.uk.saic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0701242133v2d554d45j603af0b597085fb9@mail.gmail.com>
	 <1169715782.22508.202.camel@ukabzc383.uk.saic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I didn't get a chance to try the -mm patch, but booting with acpi=off
> works - other than no acpi, of course :)
>
> What now?
Well, this should be ACPI interrupt configure issue.
Please feel free to enter a bug on bugzilla.kernel.org.
And, post acpidump output, /proc/interrupts ,lspci -vvx, dmesg for
(acpi=off ) there.

Thanks,
Luming
