Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZH3Mxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZH3Mxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 08:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZH3Mxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 08:53:37 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:40682 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZH3Mxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 08:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <37219a840908241332w2e2d45d8kd6406de3e60d1317@mail.gmail.com>
References: <20090730200714.5a7ab8a6@pedra.chehab.org>
	 <37219a840907310825n51d5a6bar79ea1f31dd889327@mail.gmail.com>
	 <20090801014053.7f53da83@pedra.chehab.org>
	 <303a8ee30908011103n3c12258icd2bfd1305b419d3@mail.gmail.com>
	 <20090811140128.211d4d11@caramujo.chehab.org>
	 <37219a840908111457o4b6abc64n52291f044b56782d@mail.gmail.com>
	 <37219a840908241332w2e2d45d8kd6406de3e60d1317@mail.gmail.com>
Date: Sun, 30 Aug 2009 08:53:35 -0400
Message-ID: <303a8ee30908300553s6d81a2cdn43145de51298afd5@mail.gmail.com>
Subject: Re: [PULL] http://kernellabs.com/hg/~mkrufky/sms1xxx
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

On Mon, Aug 24, 2009 at 4:32 PM, Michael Krufky<mkrufky@kernellabs.com> wrote:
> Mauro,
>
> Would you please send the final GPIO fix to Linus to fix the
> regression on the Hauppauge devices.  2.6.31 is in -rc7 now, and I
> would hate for this regression to not yet be solved before the kernel
> is released.
>
> I apologize for nagging -- I just prefer for fixes to be merged
> upstream *before* a kernel release.
>
> Thank you.
>
> Just as a reminder, the changeset that is still waiting for upstream merge is:
>
> *       sms1xxx: restore GPIO functionality for all Hauppauge devices

Just another reminder -- this is cutting it very close now.

I repeat, that this is a feature that worked in previous kernels but
is broken in 2.6.31.

I feel very concerned, considering that I posted a regression fix over
six weeks ago and it still has not made it into Linus' kernel tree.

I understand that you are a busy man -- Would it be easier for you if
I sent this patch to Linus, myself?

Please advise.

Thank you for your time.

Regards,

Michael Krufky
