Return-Path: <linux-kernel-owner+w=401wt.eu-S1764305AbZE0Ojh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764305AbZE0Ojh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759849AbZE0Oj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:39:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:51762 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759714AbZE0Oj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Sy1xxAafqjZ5dM2F3rEtriVVAF0XExxSI+oM3IwFZZ5o2Dh7aK2kgHHMbXQpuLRukM
         5hoTBpDpLMSgFe9vvQyDgJ8j+ZtNXRdtyKWVJAtveehQ2uQrXT2zgdKgv2BgHUnVzffP
         jjYlURcrhTVC2t8SqSA9bG0wY8qTlXE2yMbm4=
MIME-Version: 1.0
In-Reply-To: <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
Date: Wed, 27 May 2009 09:39:30 -0500
X-Google-Sender-Auth: 93f5b33509791fb4
Message-ID: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Timur Tabi <timur@freescale.com>
To: Janboe Ye <yuan-bo.ye@motorola.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 9:27 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

>> Signed-off-by: janboe <yuan-bo.ye@motorola.com>
>
> Heeheehe, This is Fantastic.

Yes, I agree.  Thanks for working on this.  I was hoping to work on it
myself later this year.  Freescale develops both ARM-based and
PowerPC-based SOCs, and some devices are shared between them (e.g. the
SSI).  Lack of device-tree support on ARM has been a real hindrance to
getting the ARM-based Linux support on par with PowerPC.

-- 
Timur Tabi
Linux kernel developer at Freescale
