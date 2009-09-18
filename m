Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZIRNwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZIRNwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZIRNwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:52:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZIRNwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tH60LEcXBl3s3gNkAZz1zfsAJtosMRgNfBuFEKEZOrFVWH9iJL08A2yQfvh1crx1r3
         F2lcwXfY6cGUQNsI9cdP0mI3NJP9kXpJ7S/FiuIFMlSzhuB2T0uoLZnMMHHNvzADWgDR
         bDB6utl50+mnoLDz+J0DBDNvDZmLke+sK7exU=
MIME-Version: 1.0
In-Reply-To: <1253122902-15647-1-git-send-email-nicolas.ferre@atmel.com>
References: <1253122902-15647-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 18 Sep 2009 15:52:16 +0200
Message-ID: <cd73a99e0909180652j6d5c8061p8d85b65b6558a7cd@mail.gmail.com>
Subject: Re: [PATCH] at91: add AC97 support to at91sam9rl and at91sam9rlek 
	board
From: Andrew Victor <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Nicolas,

> Add the support of AC97 on the at91sam9rl chip and -ek board.
> It will share the code with AVR32 ac97c alsa driver "atmel_ac97c".
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
