Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbZKXABm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbZKXABm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZKXABl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:01:41 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36153 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbZKXABk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:01:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V69Eg5lERpgqjcuT27yw7Y2W6kyvXcR5nIsF4CgC7evK2lcHpEW1rISo5gEblthLDu
         CKP8yRMMNn/GjS42H67JixMY/5JJzpQjI4FOZJIcZ9hYixhFwtpHvWsCaHyEoZ4A94pZ
         6NV8U8rJn01oWjnFsoYhsqxT9mYkcjPIWxA5Y=
MIME-Version: 1.0
In-Reply-To: <4B0B1B62.2030302@gmail.com>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
	 <20091123134002.bac1e664.akpm@linux-foundation.org>
	 <4B0B1B62.2030302@gmail.com>
Date: Mon, 23 Nov 2009 22:01:45 -0200
X-Google-Sender-Auth: 200fadd3dc278842
Message-ID: <be7a9f3d0911231601p4dcfa519q4d1504a8ee37fdad@mail.gmail.com>
Subject: Re: Vortex86SX: only works with irqpoll
From: Otavio Salvador <otavio@ossystems.com.br>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 23, 2009 at 9:31 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 11/23/2009 03:40 PM, Andrew Morton wrote:
>>> [    0.000000] ACPI Error: A valid RSDP was not found
>>> (20090903/tbxfroot-219)
>>
>> No ACPI.
>>
>> Please raise a report against acpi_bios@kernel-bugs.osdl.org at
>> bugzilla.kernel.org, thanks.
>
> I believe that just means the machine doesn't support ACPI at all..

Yes; same as me.

Andrew should I report it anyway?

>From Alan message I understand that he believes it is a firmware
issue. I tried (without success) to contact DM&P about it asking for a
newer BIOS but nothing yet.

If I could workaround it, it would be nice since it could avoid issues
for users of those devices. I did research on Internet and found a lot
of users having the network adaptor not work and like and those
problems mostly looks like same issue I'm having.

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
