Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZGGPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZGGPrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZGGPrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:47:11 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:59313 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZGGPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Dz7KcL0w/9wPtiOgnQueHYvBB/PGAHEYB9PV2SxE1p7zsZoEzpKycUBAqhdJaM79eR
         EYCj2xTyuP/tLKxb03Bfxeg/3lWKIGjIu2drRz0Hlg5chONR9QojdCT4ZnHWZsIbsAUR
         syLJx9c6rOvCgJGmKLmS7aI/4DpmI9W90XvIc=
MIME-Version: 1.0
In-Reply-To: <1246981272.9777.9.camel@twins>
References: <a5d9929e0907070825q41de40eeo5e337a4885615909@mail.gmail.com> 
	<1246980592.9777.0.camel@twins> <a5d9929e0907070836s1d75d874p65323b1b62eb63c3@mail.gmail.com> 
	<1246981272.9777.9.camel@twins>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:46:48 +0100
Message-ID: <a5d9929e0907070846w95f60b1nf278e3a1beb22cbd@mail.gmail.com>
Subject: Re: [PATCH 2/3] Increase lockdep limits: MAX_LOCK_DEPTH
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 4:41 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>
> A: Because we read from top to bottom, left to right.
> Q: Why should I start my reply below the quoted text?
>
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
>
> A: The lost context.
> Q: What makes top-posted replies harder to read than bottom-posted?
>

Interesting :-).

Ill keep that in mind, apologies.

Joao Correia
