Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXGJQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXGJQrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbXGJQrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:47:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:56878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbXGJQrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aBT0iiXKVcTXPEPKG+SUIxfD3XfD6Xx0BgTih1FlPDfS20VNQIvdZxtn4wHN6sRb4aDErw6pvo46LOfrBoEDfkUDn/6ivWJJoHIRKhvgeGqxX2jgiBuBKJ1Zlu2papKzsMxT+AFe3q3dNL71w4CcNF/CnbsE84JMHq+yp150SHQ=
Message-ID: <48f7fe350707100947g1453a790n3e425935994003a9@mail.gmail.com>
Date: Tue, 10 Jul 2007 12:47:08 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: ACPI: EC: Handler for query 0x80 is not found!
In-Reply-To: <48f7fe350707100653w6f01c645u388fbb4691b74c6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350707100653w6f01c645u388fbb4691b74c6b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that this message goes away if I reboot my computer... So a
fresh boot it errors, on reboot it does not error.

On 7/10/07, Ryan Hope <rmh3093@gmail.com> wrote:
> Ever since 2.6.22-rc6-mm1 I have been seeing these messages in dmesg:
>
> ACPI: EC: Handler for query 0x80 is not found!
> ACPI: EC: Handler for query 0x81 is not found!
>
> This did not happen in 2.6.22-rc4-mm1. Does anyone have any clue what
> this is about?
>
