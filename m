Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbXKCKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbXKCKJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 06:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbXKCKJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 06:09:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:65096 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbXKCKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 06:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=caEontqHISCxAUPsEQXhhXoiJtzxXQa5nC5Mhru+yT7yJfW5ZZtIZngHUlHc8n2HwCQPA+ni5oAUqjqE9rKcmCznqUXYGdZWgdzThJb7eQ/nmsvLDdvZrdxvm2cqcOzgwy25EH14LmlUqxonjyZ+r4cyWVkEkcxv1faZAUOYzXM=
Message-ID: <472C48BC.30809@gmail.com>
Date: Sat, 03 Nov 2007 13:09:00 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.24: make /proc/acpi/ac_adapter dependent on ACPI_PROCFS
References: <200710302321.19497.arvidjaar@mail.ru>
In-Reply-To: <200710302321.19497.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> Let's make it consistent with battery code; also it fixes HAL case of 
> duplicated adapters. Somebody will have to sort out HAL with ACPI_PROCFS 
> case ...
>
> -andrey
>   
Andrey,
Please excuse me, I mis-understood your comment, and thought that you 
are trying to
do AC adapter register/unregister at on/off.

Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
