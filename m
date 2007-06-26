Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbXFZPhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbXFZPhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbXFZPh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:37:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbXFZPh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tsJaTVC0eDAA0c2c2a9/9N8M7BrgHAv130EvyucZeMIpfZPO1KU7pgGE0Z2hfujuwjaAaisrBNymBaDxurU7PCII47vPdMY3PV7AizaNMlYBGO+BcyvSnphkZHAqHW0/saWXOhxOp0nNAIZW5l8WSgEJsCsw9FCmKMDiuzx/pyE=
Message-ID: <81b0412b0706260837w44c8b690o9113f58cfe12c446@mail.gmail.com>
Date: Tue, 26 Jun 2007 17:37:25 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Danillo Aquino" <danillo.aquino@gmail.com>
Subject: Re: Kernel Options.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8277674d0706260702p4c750351gc1e9458ea1eadc36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8277674d0706260701u3abac42eh817b72fa095e2756@mail.gmail.com>
	 <8277674d0706260702p4c750351gc1e9458ea1eadc36@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Danillo Aquino <danillo.aquino@gmail.com> wrote:
> Which patch necessary to qualify the following options in kernel, I am
> using kernel 2.6.17
>
> IP: DHCP support
> Root file system on NFS
>

None. It is done completely in userspace. DHCP with something like dhclient,
udhcp and the like. Google for root on NFS.
