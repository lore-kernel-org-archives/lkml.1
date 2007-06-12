Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbXFLKpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbXFLKpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXFLKo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:44:56 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:17461 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbXFLKo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dN6gzRyCFBdO/laPjm+9zVewcOYr1Rs90gJH9A3YE78vDWt2OYozMPnYwmeW9vXESIUCBkJjCUZXAG7DYpz+16n4NlmEFsFTMGKlnPyVIlaYWxfMGOg/lEZ0gw4Kt74e4OZDRggpTfhRmBsAVmov7TjxdddPbwnxqifMlM/21BE=
Message-ID: <5699f8f00706120344h40fe6f88vb7601c9326bd589f@mail.gmail.com>
Date: Tue, 12 Jun 2007 12:44:54 +0200
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <466E65A7.3000206@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E65A7.3000206@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
> I bought a VIA PC2500 board a few days ago - this
> new series of their mobos,
>
> This beast looks nice - after replacing their cooling
> system (that had a small fan on it) with larger but
> fanless, -- it becomes a almost real PC (1500MHz CPU),
> equipped with quite nice crypto and multimedia abilities,
> but with very low power consumption and very quiet.
>
> But the thing is - it doesn't quite work.

Try disabling CPU frequency scaling, VIA CPU's often have problems
with changing their frequency.

Furthermore, did you do any testing of the board before you took the
fan off? Was it stable then?

Wander.
