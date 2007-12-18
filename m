Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXLRKOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXLRKOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXLRKOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:14:44 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:30147 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbXLRKOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RY0Iz5/7qrLsBcQq4ByYvq4zgDDZnfxQ13Fs9duKxcwMSvnkc8k2XsiyGpOZtC4SgZ/tP/rLfbxHrzOJuaTkbmOqRZoP8D9+WL2zWn9CGTn8mrSIQ9cIol3vLsL5dDMtQ7AkHdttBoNbQcxQdANtbqXrDbOI4IPYZpwokBbHrvo=
Message-ID: <3efb10970712180214g374749cbh940958e1eff7185c@mail.gmail.com>
Date: Tue, 18 Dec 2007 11:14:42 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH v2] atmel_serial: Clean up the code
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1197971591-23890-1-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197971591-23890-1-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: 58170c8655bc330e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> Please note that I'm not trying to steal the show here -- I just want

That did not even come to my mind at all...
I am happy with everything that helps making this driver better.

What shall we do first from here, splitup of the interrupt handler? Or
DMA patch?


Kind Regards,

Remy
