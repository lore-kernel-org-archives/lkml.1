Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYESQjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYESQjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYESQiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:38:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:58650 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYESQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:38:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qieOsEt1UoQ15l8X3VJIDUOJd47yJvo0AzBl7nROcr3nrK9uML2MPZFTqOHNZNeTSwuF2Xkp21agZD1kU06B3c3CpoH65Vx4u25RTPvPmCb9cJlE5dSQ2jOzAZQHK4LJOhrWchhV8cEet8RA1OY1x1Iv4KX5spczUXxb0JEBf5E=
Message-ID: <438397970805190938t195d9a8ejfd5b0ca1409714ab@mail.gmail.com>
Date: Mon, 19 May 2008 09:38:52 -0700
From: "Kallol Biswas" <nucleodyne@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: HDMI Audio Support in ALSA
In-Reply-To: <75b66ecd0805190916r7ce21667laf19783dfa47cdd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>
	 <75b66ecd0805190916r7ce21667laf19783dfa47cdd7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can ALSA handle HDMI audio frames? It does not look so.

Do you need a pointer to HDMI audio spec (L-PCM, IEC 60958 IEC 61937 etc.)?

On 5/19/08, Lee Revell <rlrevell@joe-job.com> wrote:
> On Mon, May 19, 2008 at 12:04 PM, Kallol Biswas <nucleodyne@gmail.com> wrote:
>  > Hi,
>  >   We are building a HDMI capture card that has a HDMI audio device.
>  >
>  > The audio device needs to be integrated with ALSA framework.
>  > Unfortunately the audio is not supported in ALSA.
>  >
>  > I understand that work is being done at this moment to support the audio format.
>  >
>  > Any information on when the support will be available is helpful.
>
>
> You don't provide nearly enough information.  What exactly is missing
>  from ALSA that you need?
>
>  Normally if you develop a new device you must write a (GPL'ed) ALSA
>  driver for it.
>
>
>  Lee
>
