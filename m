Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXEQMnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXEQMnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbXEQMnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:43:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:34388 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbXEQMnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W0NP2J49tcSz3lLIOsCZ9lfBQbAbdtujCav3V3DEEZ0gO4LI3KzUzOytZNtOzWqqQwbQP0gBAZ9B4cILDBN4TK/KLuUvB01kvH3kxKL/gHDLQrXpXnGmuHDAx2fy64qgDl6ad/9KYn9lQbixhNqyd8YmEFhA//1Py+WGVmzLZ/c=
Message-ID: <68676e00705170543k26d1c71oc978d4c5998d4060@mail.gmail.com>
Date: Thu, 17 May 2007 14:43:41 +0200
From: Luca <kronos.it@gmail.com>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: radeonfb and X800 cards
Cc: "Daniel Drake" <dsd@gentoo.org>,
       "linux list" <linux-kernel@vger.kernel.org>, Jimmy.Jazz@gmx.net
In-Reply-To: <1179367164.32247.256.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464BB43D.2020407@gentoo.org>
	 <1179367164.32247.256.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Wed, 2007-05-16 at 21:47 -0400, Daniel Drake wrote:
> > Hi,
> >
> > Did anything happen to the patch titled "radeonfb: add support for newer
> > cards"?
> > http://lwn.net/Articles/215965/
> >
> > Jimmy at http://bugs.gentoo.org/174063 has extended upon this with some
> > further fixes based on code the in X11 driver. The patches are on the
> > bug report.
> >
> > Ben, where can the most up-to-date radeonfb code be found?
>
> upstream. I haven't released anything else so far. Does the patch still
> apply ?

Nope, but I still rebase against current kernel for my own use. I can
send an up to date patch when I get home this evening.

Luca
