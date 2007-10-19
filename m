Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbXJSP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbXJSP6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXJSP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:58:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:50505 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbXJSP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OL/FTPeFItMU6Wfcv1PhjlZAzdFypL0JzpI/pHlDz2FdJMm7WePi4F6FrGpWdA7sAzZGtH9dbQrWvD6AyJg3eH/kgDk6xldgx86COUTKKBv0lyB1DIn8wg4uBdKXp9awGf+Lz+QFePUSzq3Ms7cvgwci8hico1mqZuRYNfXVcVc=
Message-ID: <2c0942db0710190858n647192d6t270e43b2a3075320@mail.gmail.com>
Date: Fri, 19 Oct 2007 08:58:05 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
Subject: Re: PROBLEM: 2.6.23.1 Freezes on GB data transfers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <12bfabe40710170420m6882ea8eg3b8e6e7db72a0cdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40710170420m6882ea8eg3b8e6e7db72a0cdd@mail.gmail.com>
X-Google-Sender-Auth: 94ffdeff2126ef9a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Giangiacomo Mariotti <gg.mariotti@gmail.com> wrote:
> Linux Kernel 2.6.23.1 freezes on GB data transfers.
>
> Pc completely freezed while transferring 4Gb of data from
> dvd(/dev/hdc) to hd(nothing else was happening, cpu general usage at
> 5-6%).Except for this,it has been working flawlessly for 1 day,but
> when I tried to transfer 4Gb of data from the dvd to the hd,after
> having completed 60% of the transfer, the system became completely
> freezed,no keyboard,no mouse,no consoles,nothing, and the Caps Lock
> LED started to blink.

The blinking Caps lock LED means that your system is Oopsing. Please
try your test again from a console (not from X), and see if an oops
message is printed out. If it is, you'll need to either copy it down
or take a photograph of it with a digital camera, then post the text
of it or post a link to the image.

Ray
