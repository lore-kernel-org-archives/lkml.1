Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbXITCqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbXITCqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 22:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXITCqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 22:46:07 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:12513 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbXITCqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 22:46:06 -0400
X-IronPort-AV: i="4.20,276,1186372800"; 
   d="scan'208"; a="51866291:sNHT27284775"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David McCullough" <David_Mccullough@securecomputing.com>
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
Date: Wed, 19 Sep 2007 22:46:26 -0400
User-Agent: KMail/1.9.5
Cc: uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       "Bernd Schmidt" <bernd.schmidt@analog.com>,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       lethal@linux-sh.org, miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
References: <1190102965.4406.9.camel@roc-desktop> <200709192131.09469.rgetz@blackfin.uclinux.org> <20070920015525.GA16615@securecomputing.com>
In-Reply-To: <20070920015525.GA16615@securecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709192246.26956.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Sep 2007 02:46:04.0223 (UTC) FILETIME=[630E44F0:01C7FB30]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19 Sep 2007 21:55, David McCullough pondered:
> Jivin Robin Getz lays it down ...
> > On Tue 18 Sep 2007 04:09, Bryan Wu pondered:
> > > From: Bernd Schmidt <bernd.schmidt@analog.com>
> > > 
> > > This just adds minimum support for the Blackfin relocations,
> > > since we don't have enough space in each reloc. The idea
> > > is to store a value with one relocation so that subsequent ones can
> > > access it.
> > > 
> > > Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
> > > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > > Cc: David McCullough <davidm@snapgear.com>
> > > Cc: Greg Ungerer <gerg@snapgear.com>
> > 
> > Adding the other appropriate maintainers. for h8, m32r, sh and v850.
> 
> Looks fine to me,  obviously impacts the existing arches very little.
> Can't see why it shouldn't get included,

Is that Australian for Acked-by:? :)

-Robin
