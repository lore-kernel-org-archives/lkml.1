Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbXISHx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbXISHx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbXISHxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:53:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:50121 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbXISHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nvQDaiJGFDNUIJ0pshtepomuuabIcbKumKm1Vo91hPZpBrd6pgAMRAHRHWHCMs8OqD2RObBtY9YbrWsTKTtCHKCb87mhU1zOJsbeZNAlChoY44OFRayiwUVOvRDOZZHRxqxowGe+h0hgjqfGt87l6FjqBK/i1A17jtl2h9F0bB8=
Message-ID: <517f3f820709190053i34e3a1caufc84cb90cd400ebe@mail.gmail.com>
Date: Wed, 19 Sep 2007 09:53:18 +0200
From: "Michael Kerrisk" <mtk.linux.lists@gmail.com>
To: "sreenath Angadi" <sreenath.angadii@gmail.com>
Subject: Re: Query on Real Time Signalling in Linux 2.6.16 kernel
Cc: linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
In-Reply-To: <23eb1e460709112217q3e174de3l1b2539995adec1a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <23eb1e460709112217q3e174de3l1b2539995adec1a0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, sreenath Angadi <sreenath.angadii@gmail.com> wrote:
> Hi,
>  I would like to use the Real time signalling mechanism. When I try to
> use "F_SETAUXFL", compilation fails. While looking through the
> archives I found a patch  one-sig-perfd-2.4.4.patch.gz at
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0105.2/0642.html which
> needs to be applied for the support.
> I am using Linux 2.6.16 kernel. So I can't apply this patch directly.
> Is there a different patch for this kernel or is the support in built.
> If the support is already present, then any pointers on usage(RT
> Signalling) would be of great help.

Sreenath,

RT signals are supported on Linux.  But, you don't actually say what
you want to do with RT signals, which makes it difficult to answer
your question.

Cheers,

Michael
