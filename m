Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0BAQTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:19:24 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:34897 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab0BAQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T6WGiKtg+NRg/FGiBHYLvQvVF+PbSAkyCGIqghbAwrM53IciWnyujol1D10o7oUiqR
         /rK3hz3SWmx2DqmqwCXQfJTSMOk4H0OVxiPxKcRn2oG9XiLbT+vyEOtlnsEvKLhAaT/z
         CUEo+Jm6Uga8StMYh/lZC+m8NIdQdiITDXVtY=
MIME-Version: 1.0
In-Reply-To: <20100201142605.GB13428@linux-sh.org>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
	 <20100128124038.8982.82995.sendpatchset@rxone.opensource.se>
	 <20100201141057.GB1340@ucw.cz> <20100201142605.GB13428@linux-sh.org>
Date: Mon, 1 Feb 2010 17:19:21 +0100
Message-ID: <63386a3d1002010819r63aae9edn2f5bc7e7f08a5fdf@mail.gmail.com>
Subject: Re: [PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Pavel Machek <pavel@ucw.cz>, Magnus Damm <magnus.damm@gmail.com>,
       linux@arm.linux.org.uk, eric.y.miao@gmail.com, tony@atomide.com,
       linux-kernel@vger.kernel.org, khilman@deeprootsystems.com,
       ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/1 Paul Mundt <lethal@linux-sh.org>:

> SH-Mobile (G series, in this case) is a line of SH/ARM multi-cores. They
> contain both SH and ARM MPUs and are built up almost entirely on SH IP
> blocks.

Jaysis, that's one odd bird. There must be some upside to designing
things like this, is there some paper or conference presentation on the idea
behind this thing somewhere out there? I just get very curious!

Linus Walleij
