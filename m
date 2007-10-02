Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXJBInU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXJBInU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXJBInF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:43:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:59568 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbXJBInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:43:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TP0kpiK13L+AURLJBrUs0BegdErZ+prpp/k/VfTgquhp+YRS/aaNHZsRjkF0qF1FcAYzFhe9l+9yp1G150HEcuOYH2I8Bn1j1+UDtrx6wXEjcGiL1bQVZ4yKaGeZwhTKpNVqF1UbrCh15nqsmH6t+9pTWvTBdholfJ1GDSKKdrg=
Message-ID: <4701EA71.2000609@gmail.com>
Date: Tue, 02 Oct 2007 15:51:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: hgsolari@gmail.com
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46FC4384.7080607@df.uba.ar> <46FCCD57.2020507@gmail.com> <47014740.5080002@df.uba.ar>
In-Reply-To: <47014740.5080002@df.uba.ar>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hernan Gustavo Solari wrote:
> Tejun
> 
>    netconsole, pritty nice debunging system... but (yes, there is always
> a but) it does not get to run.
>    the method was well implemented, adding the acpi=off it sends the
> information to the receiving machine (I can even see passing a
> netconsole probing message in the machine under testing), but without
> turning off acpi it does not reach the point of loading and,
> consequently, it does not send a byte to the receiving machine.
> 
> Hence, result: empty output.

Hmmm.. Are netconsole support and network driver built into the kernel?

-- 
tejun

