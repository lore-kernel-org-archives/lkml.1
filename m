Return-Path: <linux-kernel-owner+w=401wt.eu-S965349AbZLHBJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbZLHBJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbZLHBJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:09:32 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:34101 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965270AbZLHBJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:09:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=u0v0Wz8J9CO+O5knKmkzj0i9u05Yw72HY65eKGAXfx9OcPLUlG+jKVZsURjp1Gol9b
         +YYTR2yXmRrcNm2tDbknCv/auTVdJwdSyXTYL7onP+KFhpcU+1JAsVrDSS32jC+vUXib
         O6wBKqVf1zTL3EyOtzXbbbY6zxbC90X3up4Lo=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
Date: Mon, 7 Dec 2009 18:09:37 -0700
X-Google-Sender-Auth: 1c3bde5dd0f663fe
Message-ID: <e9c3a7c20912071709s200074bbhe6ce07c22fcdbb55@mail.gmail.com>
Subject: Re: [PATCH 0/5] sh: fix the shdma driver, improve dmatest, support 
	sh7724
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 11:44 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi
>
> Not all of these patches are connected, only the ones, affecting the same
> file should be applied in a specific order, otherwise the patches are
> independent and can be applied separately.

I'll take 1 and 2 straight away, 4 with the bool fixup and a changelog
explaing the dmae_is_idle() change, and 3 after an ack from Nobuhiro
(or when I get a chance to look at it a bit deeper).

Thanks,
Dan
