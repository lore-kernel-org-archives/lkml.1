Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXBXMMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXBXMMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbXBXMMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:12:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:21779 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbXBXMMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:12:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z9s03S6X6hVLKvv6QF+Ag2MELFhO3MuUo7OYB+YRQFDqkDDM00zPIrRftWZwDs/JBZBENP8cdgGBIAztfvgPEDuFchzTwLSbbayKb9qx/khD3jsK9EuKwFATMuMcv+I6gPiMbkwxI7A6eU5cSxKkTLTE/6U9XX+iZz/FzHz03K4=
Message-ID: <b637ec0b0702240412p531299ecn797fdef7e4c53e89@mail.gmail.com>
Date: Sat, 24 Feb 2007 07:12:44 -0500
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: 2.6.20-ck1
Cc: "ck mailing list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200702162110.03355.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702162110.03355.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> This patchset is designed to improve system responsiveness and interactivity.
> It is configurable to any workload but the default -ck patch is aimed at the
> desktop and -cks is available with more emphasis on serverspace.

Hi Con.
I usually don't pay a lot of attention to benchmarks. Responsiveness
under load is much important to me.

But this is nice: I use FC6 with initng as boot process manager. With
vanilla 2.6.20 boot process takes 21 to 23 seconds; with 2.6.20-ck1
(same config, of course), boot process takes 17 to 19 seconds.

So your patchset has become my patchset of choice.

Regards,
Fabio
