Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYJAWEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYJAWEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYJAWEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:04:36 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:48257 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYJAWEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:04:36 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Pazzo Da Legare" <pazzodalegare@gmail.com>
Subject: Re: booting uncompressed kernel on x86
Date: Thu, 2 Oct 2008 00:04:26 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1a26b4920810011457t4ad93308u2cc0d2781168f332@mail.gmail.com>
In-Reply-To: <1a26b4920810011457t4ad93308u2cc0d2781168f332@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810020004.28045.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008 23:57:43 Pazzo Da Legare wrote:
> I would like to boot uncompressed linux kernel on a embedded x86,
> should I apply a specific patch for this? I'm using grub boot loader
> which should boot using elf image but I cannot find any clue.
> Should I switch to another bootloader?

I did something some time ago - but it's only a quick hack to make my really 
slow (386DX/25) machine boot faster - see http://lkml.org/lkml/2005/7/1/206

>
> TIA
>
> pazzodalegare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ondrej Zary
