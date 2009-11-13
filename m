Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZKMFTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZKMFTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 00:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZKMFTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 00:19:17 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56645 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZKMFTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 00:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DgIkQRXyswTCcvCIEgYS6yHo/18/l3jYLKQo7j4OrzRs9H8aOmVif0gZuywVR8YNS2
         PzvSAUDfyTFk0IQQmCi2/yaBPl+p8ofZjP5ORDgAyVGGRL8BkvarOXS7Nv98G9Pffzmv
         OLpCpquseqrw95c0yyd4+fGUu0O3rIEtexd70=
MIME-Version: 1.0
In-Reply-To: <646765f40911121945p7080b920s230b92fb02b04ae7@mail.gmail.com>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <20091113030950.GB4054@tuxdriver.com>
	 <4fb5db50911121925t1a6770ddtbd5f01477470046d@mail.gmail.com>
	 <646765f40911121929p5aa416c3o99f33bd5b5d8c5cb@mail.gmail.com>
	 <1258083706.7715.16.camel@violet>
	 <646765f40911121945p7080b920s230b92fb02b04ae7@mail.gmail.com>
Date: Fri, 13 Nov 2009 10:49:20 +0530
Message-ID: <4fb5db50911122119j1271a5f4ra718aa8fb34f9bff@mail.gmail.com>
Subject: Re: [patch 0/1] Adding radio type FM
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

Thankyou for all the comments on the patch.Yes if you see the toshiba
Laptop series which have an FM key that enables FM.If still People say
that we cannot take KEY_FM yes we will go ahead and will resubmit a
patch with only RFKILL for FM

Regards,
Ram.

On Fri, Nov 13, 2009 at 9:15 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> On Fri, Nov 13, 2009 at 14:41, Marcel Holtmann <marcel@holtmann.org> wrote:
>> Hi Julian,
>>
>> please stop CCing majordomo@vger.kernel.org since that one is not a
>> mailing list.
>
> I never intended to: I didn't check the CCs when I hit reply-all.
>
> I realised it had been CC'd right after it sent me an email telling me
> (in a rather verbose fashion) that I was an idiot.
>
> Thanks,
>
> --
>
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> .Plan: http://sites.google.com/site/juliancalaby/
>
