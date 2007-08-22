Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXHVIm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXHVIm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXHVImH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:42:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:60373 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXHVImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fewX4vUv3Y7mFR2zHB3FCTNku4zVwKI9U7EUpmK5c2LBXHP2BlgDlUKyWTTyfoBIlyhRdI626wXRCvnsZrtcf24oHN1/ZxQZAStyuvPEwYjOwv2rl0m/zSxoJXIhS4cPmHdYjJ2Pg/uahV66cXgE8k3TtFp6qCgWa6o0k6ZirRw=
Message-ID: <6bffcb0e0708220142t1d3f5d66o5a43b1b1c4565ed2@mail.gmail.com>
Date: Wed, 22 Aug 2007 10:42:03 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: RFC: drop support for gcc < 4.0
Cc: "Jarek Poplawski" <jarkao2@o2.pl>, "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708221009010.20435@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070821132038.GA22254@ff.dom.local>
	 <20070821093103.3c097d4a.randy.dunlap@oracle.com>
	 <20070821173550.GC30705@stusta.de>
	 <6101e8c40708211441g2ae20412u877082eb611f595e@mail.gmail.com>
	 <Pine.LNX.4.64.0708220956540.20435@fbirervta.pbzchgretzou.qr>
	 <20070822080854.GD1684@ff.dom.local>
	 <Pine.LNX.4.64.0708221009010.20435@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 22/08/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 22 2007 10:08, Jarek Poplawski wrote:
> >On Wed, Aug 22, 2007 at 09:57:04AM +0200, Jan Engelhardt wrote:
> >>
> >> On Aug 21 2007 23:41, Oliver Pinter wrote:
> >> >I think it's bad idea, when removing support for gcc3.x, while some
> >> >people using debian 3.1 at now and under debian 3.1 the default
> >> >comiler is 3.3.5, when I good know or not!?
> >>
> >> They always lag behind.
> >
> >Yes! Probably that's why they are so darn good!
>
> ISTR that even Ubuntu overtook Debian... what about Debian 4.x?

They are using gcc 4.1.1 as default
http://packages.debian.org/stable/devel/gcc

Anyway, IMO dropping support for a compiler just because of warnings
it is a bad thing.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
