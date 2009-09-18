Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZIRNxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZIRNxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZIRNxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:53:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44253 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZIRNxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FdfMMepmAVNDx9O3YpQ3C1i3dyrufeXud1fWToni+AW9LRMsftllnoDl3SUYSfnBOt
         8/0XTkk1RX1QCDVkCwVHoJgF4hTudn/yt+1TShfo3HKOUo5siFrQumt0oWDpbBUgr5ym
         mwVUpg4KB4xp+GQ/fVHuqUtHGupb4IPmlOg/I=
MIME-Version: 1.0
In-Reply-To: <1253122902-15647-2-git-send-email-nicolas.ferre@atmel.com>
References: <1253122902-15647-1-git-send-email-nicolas.ferre@atmel.com>
	 <1253122902-15647-2-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 18 Sep 2009 15:53:33 +0200
Message-ID: <cd73a99e0909180653p29ea4e4u2866436ea4a7e22d@mail.gmail.com>
Subject: Re: [PATCH] at91: add AC97 support to at91sam9g45 series and 
	at91sam9m10g45ek board
From: Andrew Victor <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Nicolas,

> Add the support of AC97 on the at91sam9g45 chip series and -ek board.
> It will share the code with AVR32 ac97c alsa driver "atmel_ac97c".
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
