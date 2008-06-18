Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbYFRJn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbYFRJn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYFRJnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:43:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:46355 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbYFRJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:43:46 -0400
Message-ID: <29ab51dc0806180243h46b4373ej1e29dcf425eef994@mail.gmail.com>
Date: Wed, 18 Jun 2008 18:43:45 +0900
From: "Nobuhiro Iwamatsu" <iwamatsu@nigauri.org>
To: oihana <munoz.o@ikusi.es>
Subject: Re: Change console to another UART
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1213773664.15059.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080617223023.GH25911@cs181133002.pp.htv.fi>
	 <1213773664.15059.26.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/6/18 oihana <munoz.o@ikusi.es>:
> Hello,
>
> I am working with a STi7109 and mb411. The STi7109 has 4 UARTs and they
> are configured by default as follow....
> - UART0 is reserved for SC0
> - UART1 is reserved for SC1
> - UART2 is reserved for console
> - UART3 is reserved for KGDB
>
> What I need is to have the Console in the UART1 because I need the UART2
> free, and I have enough with one SC (SC0).
>
> I realized that if I change on my STWorkBench the Kernel Debug
> configuration, from ttyAS0 to ttyAS1, the console comes out from the
> other serial port, but it still uses the UART2.
>
> So I tried to change the configuration in the stasc.c
> (kernel/src/drivers/serial/stasc.c).
Hmm? I could not find it.
Is this a thing peculiar to ST?
You should send an email to support of ST if so.

Best regards,
 Nobuhiro
