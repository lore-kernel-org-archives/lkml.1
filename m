Return-Path: <linux-kernel-owner+w=401wt.eu-S934515AbYD1Nnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbYD1Nnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbYD1Nnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:43:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:45235 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbYD1Nng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FRPRz+H1WrJ/wRyoOQgePEZFn4vNUwSXP1inGVL3LwJwq4SdhKxSCeWngkrKuV9WucjRpctl1LtBnpq88OrfE5m9y21Poygs40GNMTe9j8fWFo4CSGKfmb7BIqkjbHmEUF+cAsjdjMf6fGu7fq65TJkCfTKIshLDLIndz+Ooio0=
Message-ID: <90edad820804280643p43509911gd7b497131c3f5004@mail.gmail.com>
Date: Mon, 28 Apr 2008 17:43:25 +0400
From: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: x86: fix a couple of sparse warnings
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080428133756.GJ16379@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
	 <20080428123809.GD27997@elte.hu>
	 <20080428133756.GJ16379@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/28 Adrian Bunk <bunk@kernel.org>:
>
> On Mon, Apr 28, 2008 at 02:38:09PM +0200, Ingo Molnar wrote:
>  >
>  > * Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
>  >
>  > > Hi Ingo, Peter, Thomas,
>  > >
>  > > Here is a couple of patches that fix sparse warnings produced while
>  > > compiling defconfig for i386:
>  >
>  > thanks Dmitri, applied.
>
>  /me wonders what was wrong with http://lkml.org/lkml/2008/4/23/131
>     that contains a superset of the first patch
>     (and got no response at all)

Adrian, I am sorry for duplicating your work. The clash wasn't intentional: I
did not notice your earlier patch in the high traffic of this mailing list.

Thanks,
Dimitri
