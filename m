Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZKDTeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZKDTeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZKDTeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:34:46 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40565 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbZKDTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=h+BaOoxvBbimywQPsudRTTF1Tq/iIEx2+xVMqGD3MMgFIkHF3fJjFsYt22iB83FH73
         8MX98VoS3G4qtdoCahS4sR85lehtTgxK0eB/4V/wnSkwKbGbYij7JrdNUWSyIm4/FR5d
         WCLId3WxeKVRryaIaqzPVBte3WKyI70m2yG74=
MIME-Version: 1.0
In-Reply-To: <20091104173404.28463.65125.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173404.28463.65125.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:34:49 +0100
Message-ID: <14add3d10911041134m3c4b3e9es9a86a26114610a8d@mail.gmail.com>
Subject: Re: [PATCH 17/41] rt2800usb: add rt2800_rfcsr_[read,write]() wrappers
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:34 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add rt2800_rfcsr_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
