Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbXFKQxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbXFKQxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbXFKQxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:53:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:10295 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbXFKQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W6Ful1DtriuGdu4RdZis4AgG+OYLWxZ4fnqDTd9NTG+aDRNLsLnw9Tk2F7oYvXyfqufrm1MPbrP85nLIoyT1fegg9XjT6AyQztQdfVrFJiksZcgtAwwwSAwDF3m/fZ3ndwzi7k2xLNb7bNG2MfmQzag1XGgD9WVKwdty+Rts45Y=
Message-ID: <d120d5000706110953l26e73559v75c2aef90f03e502@mail.gmail.com>
Date: Mon, 11 Jun 2007 12:53:28 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Daniel Ritz" <daniel.ritz@gmx.ch>
Subject: Re: [PATCH] Fix broken ifdefs in usbtouchscreen
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Ondrej Zary" <linux@rainbow-software.org>
In-Reply-To: <466D7B38.8030403@gmx.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466D7B38.8030403@gmx.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Daniel Ritz <daniel.ritz@gmx.ch> wrote:
> dmitry was a bad boy...:)
>
> Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

Yep, that was me. I already had a patch lined up but I will take this
one as it has been tested, thanks!

-- 
Dmitry
