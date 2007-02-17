Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbXBQCP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbXBQCP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932641AbXBQCP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:15:27 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:38815 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbXBQCP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:15:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gV6oCEks8i+jKCaYhIh1UQmOwznhYpdGXUJu4jjUvtrBGEm88AtX5fMiF5kEjmesdP2Koyi/kffOnpm2TSNX/QXAYAPYQ4EewN7JSRnrJBhBQlUBIpbFmRgJpMxa5xauBObLpWtYlfAEiYZM7QAY5/xDsNpqJpQ7IJkYT8D3ZJE=
Message-ID: <b14e81f00702161815x13c25936r49f540beeda3e334@mail.gmail.com>
Date: Fri, 16 Feb 2007 21:15:25 -0500
From: "michael chang" <thenewme91@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] Re: 2.6.20-ck1
Cc: "ck mailing list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200702171213.40718.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702162110.03355.kernel@kolivas.org>
	 <45D651FD.3040804@redhat.com> <200702171213.40718.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> I'm thru with bashing my head against the wall.

I do hope this post isn't in any way redundant, but from what I can
see, this has never been suggested... (someone please do enlighten me
if I'm wrong.)

Has anyone tried booting a kernel with the various patches in question
with a mem=###M boot flag (maybe mem=96M or some other "insanely low
number" ?) to make the kernel think it has less memory than is
physically available (and then compare to vanilla with the same
flags)? It might more clearly demonstrate the effects of Con's patches
when the kernel thinks (or knows) it has relatively little memory
(since many critics, from what I can tell, have quite a bit of memory
on their systems for their workloads).

Just my two cents.

-- 
~Mike
 - Just the crazy copy cat.
