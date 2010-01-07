Return-Path: <linux-kernel-owner+w=401wt.eu-S932489Ab0AGIuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0AGIuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683Ab0AGIuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:50:09 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:48198 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0AGIuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:50:08 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 03:50:08 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a5jjjWhFx6R35AZSvVD25u0IXTQPbdZd4zRPZbMA2bBLYlky0If+zwK72vyAEJ3PqH
         llOerfVAyyTLf9c09/J9H6RIYXjKfb1kVcCfMDFkbWi1rekWlskxvKOZHv6A5h8Aczgd
         0vbm9TFi0HgZOo4t62RyHo8GyHr2hHygmrjbE=
MIME-Version: 1.0
In-Reply-To: <20100106195339.GD23473@sortiz.org>
References: <20100105050914.32264.762.sendpatchset@rxone.opensource.se>
	 <20100106002158.GM4274@sortiz.org>
	 <aec7e5c31001052057u68deaab2y1d63a2e881ef94a3@mail.gmail.com>
	 <20100106195339.GD23473@sortiz.org>
Date: Thu, 7 Jan 2010 17:44:14 +0900
Message-ID: <aec7e5c31001070044n73b7b0bcw96e6c45885ce7691@mail.gmail.com>
Subject: Re: [PATCH] MMC: hardware abstraction for CNF area
From: Magnus Damm <magnus.damm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ian@mnementh.co.uk, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Thu, Jan 7, 2010 at 4:53 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> I applied the resulting patch to my tree, and will leave it there for at least
> a couple days so that linux-next can pick it up.
> Meanwhile, I'd really appreciate if Ian could make sure it works for him as
> well. Ian, this is the patch I'm talking about:
>
> http://git.kernel.org/?p=linux/kernel/git/sameo/mfd-2.6.git;a=commit;h=b3df6513659704ece28da3b80cc36c2a8de315ce

Thanks a lot for your help. I took the patch pointed out above and
applied it on top of latest linux-2.6 git and my kfr2r09 platform now
compiles and works as expected.

Cheers,

/ magnus
