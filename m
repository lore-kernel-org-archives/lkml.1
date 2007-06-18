Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbXFRB4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbXFRB4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXFRB4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:56:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:19734 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898AbXFRB4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:56:37 -0400
Date: Mon, 18 Jun 2007 03:56:36 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070618015636.GA8561@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Airlie <airlied@gmail.com>, Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, eric@anholt.net,
	zhenyu.z.wang@intel.com
References: <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com> <20070618001627.GA18598@redhat.com> <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:57:38AM +1000, Dave Airlie wrote:
> >Right now, I'm at a loss to explain the corruption, so it's
> >difficult to suggest what to try.
> 
> The thing is here, this is PCIE, so if there is a GPU plugged into the
> PCIE 16x slot in theory the main onboard graphics should disable, AGP
> code is used to control the GART for the onboard chip, in this case a
> plugged in card will  not use AGP, I wonder have Intel tested with a
> pcie card in place...

That is Chinese for me :/.
Do you want me to try something?

-- 
Carlo Wood <carlo@alinoe.com>
