Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYBGH1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYBGH1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYBGH1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:27:38 -0500
Received: from smtp7-g19.free.fr ([212.27.42.64]:38491 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbYBGH1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:27:37 -0500
Message-ID: <00cc01c8695b$47f66690$f9b5a8c0@pii350>
From: "Gilles Espinasse" <g.esp@free.fr>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: <linux-kernel@vger.kernel.org>
References: <1201877107.47a3307340b38@imp.free.fr> <Pine.LNX.4.64.0802062204410.23855@fbirervta.pbzchgretzou.qr>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only 
Date: Thu, 7 Feb 2008 08:30:14 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1914
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Jan Engelhardt" <jengelh@computergmbh.de>
To: "Gilles Espinasse" <g.esp@free.fr>
Cc: <gregkh@suse.de>; <linux-kernel@vger.kernel.org>
Sent: Wednesday, February 06, 2008 10:14 PM
Subject: RE: [PATCH] USB: mark USB drivers as being GPL only


>
> On Feb 1 2008 15:45, Gilles Espinasse wrote:
> >..
...
> >
> >There is the unicorn usb adsl modem driver (STM unicorn chip).
> >http://www.bewan.com/bewan/drivers/A1012-A1006-A904-A888-A983-0.9.3.tgz
> >There is some sources and a binary blob to be linked.
> >
> >The only things I know from the binary blob is that sources should be 150
000
> >lines of C++.
>
> It's 63 C++ files actually (wow, that even beats the blob-iness of
nvidia!)
> and a few files look rather empty. Their source would rather benefit
> from getting a review on LKML.
>
Just for curiosity, how could you know the number of sources files without
the sources of the blob?
Or you have them...?

Gilles

