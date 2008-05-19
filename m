Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbYESQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbYESQQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYESQQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:16:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:22686 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYESQQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:16:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FqaSKvT/eSuVAr5ljbDoOrDnFKtOBJQSi1tpxRcs1pzNxQtQpzvdOcfXryCiMdBuX2qDsvIU+e4a3y3ysAfXCBph0vDUcJKTvCKsstbYyMSXHQW6Kj8F93db1GhLdNkGf1h3fbJQNEdi+n5ajbTLCE3G1HBm8LUNAP7aICSuRwE=
Message-ID: <75b66ecd0805190916r7ce21667laf19783dfa47cdd7@mail.gmail.com>
Date: Mon, 19 May 2008 12:16:10 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Kallol Biswas" <nucleodyne@gmail.com>
Subject: Re: HDMI Audio Support in ALSA
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>
X-Google-Sender-Auth: 011e36beb1320cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 12:04 PM, Kallol Biswas <nucleodyne@gmail.com> wrote:
> Hi,
>   We are building a HDMI capture card that has a HDMI audio device.
>
> The audio device needs to be integrated with ALSA framework.
> Unfortunately the audio is not supported in ALSA.
>
> I understand that work is being done at this moment to support the audio format.
>
> Any information on when the support will be available is helpful.

You don't provide nearly enough information.  What exactly is missing
from ALSA that you need?

Normally if you develop a new device you must write a (GPL'ed) ALSA
driver for it.

Lee
