Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZFYWAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZFYWAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZFYWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:00:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:25389 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZFYWAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uzPIHI8GXYJ41KDhCjwIzEhzhA/QMAooOZXRgUpXpxD61qgsalT4yh8LdKqy64uIwh
         hlm9gsesUJGOuRXJMphhbGrJM/fwLBRGjoQvsjTrPiwGYgx6TsdEkETZdCJIfsUu/ZoM
         7fA9GpjkrW9wZ++TmpM+30wmikrYUvW6EaD00=
MIME-Version: 1.0
In-Reply-To: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 26 Jun 2009 00:00:04 +0200
Message-ID: <cd73a99e0906251500s7754a918k219de0cbc7d4c2a8@mail.gmail.com>
Subject: Re: [PATCH 0/5] at91: Introduction of at91sam9g10 SOC
From: Andrew Victor <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Nicolas,

> AT91sam9g10 is an ARM 926ej-s SOC. It is an evolution of the at91sam9261 with a
> faster clock speed: 266/133MHz.
>
> This patchset is relying on the integration of at91sam9g45 already posted. Here
> is the patch series that you will have to take into account before applying
> those patches.

This set of patches looks fine to me.

Acked-by: Andrew Victor <linux@maxim.org.za>
