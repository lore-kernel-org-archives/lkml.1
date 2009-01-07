Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZAGRoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZAGRoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZAGRoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:44:10 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56025 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZAGRoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:44:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UHSjBHAe7iuBc2ioRYvHNoy2+8XSD6f1EAzXkGGuV27h02VjTxM4YCFjAxZtmyJbdl
         vL+oOt43A1thoxfW0VS3QbqQn/tZAGIwD2OaCmfiPR/Y4S8Iq/9wAnnTUFjpfD6T3mr7
         h1GG+PGbZIlSH3pNg+W3DOaCQUQ+1+IFF0K6c=
Message-ID: <48f7fe350901070944y558366f0j9a23b12a993c4355@mail.gmail.com>
Date: Wed, 7 Jan 2009 12:44:03 -0500
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 0/6] v2: Asynchronous function calls to speed up booting and more
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20090107070810.675799a5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105201508.23e98b4b@infradead.org>
	 <48f7fe350901061919l55006cd6v842e3f7a40e4cd0c@mail.gmail.com>
	 <20090107070810.675799a5@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes it boots with out the acpi patch

On 1/7/09, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 6 Jan 2009 22:19:33 -0500
> "Ryan Hope" <rmh3093@gmail.com> wrote:
>
>> i can't boot with these patches... the kernel panic was something
>> along the line of:
>>
>> ata_piix: device unavailable because of BAR 0 collisions
>
> ok as a hunch.. could you try this but without the ACPI part of the
> patch?
>
>
> --
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
