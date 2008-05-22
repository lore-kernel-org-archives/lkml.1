Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYEVR6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYEVR6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYEVR6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:58:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:29181 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbYEVR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PIse/E1cE8zbNg9JW6vs+wCLaN8fBKsipdQtdwtdv7P1DpThwpkVe7QFdi9lBS5ZJ3tHdlbOq7v33ssHxa58K5xXvcFmH3YNHxfhajs1FRsubxg8Uw9kQPVNeokaPf5mL+b3TS5x7Kp9/b9iImIcisidvsWlycSI8bx/tDQKKZ8=
Message-ID: <86802c440805221058k3b8d02bbm981ae0f8df698a66@mail.gmail.com>
Date: Thu, 22 May 2008 10:58:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4835471D.3090000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805180118.57863.yhlu.kernel@gmail.com>
	 <200805211840.18619.yhlu.kernel@gmail.com> <4835471D.3090000@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 3:12 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> use find_e820_area to find addess for new RAMDISK, instead of using ram
>> blindly
>>
>
> Unfortunately this patch does not resolve the problem for me either.

boot log from serial console?

doesn't fail with dom0 or domU? FV?

YH
