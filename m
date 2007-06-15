Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbXFOQUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbXFOQUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXFOQUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:20:43 -0400
Received: from outbound-mail-08.bluehost.com ([69.89.17.208]:50933 "HELO
	outbound-mail-08.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752165AbXFOQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:20:42 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Fri, 15 Jun 2007 09:20:24 -0700
User-Agent: KMail/1.9.6
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
References: <200706071530.51552.jesse.barnes@intel.com> <200706141418.42082.jbarnes@virtuousgeek.org> <4672681D.7020601@macroscoop.nl>
In-Reply-To: <4672681D.7020601@macroscoop.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150920.24490.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 15, 2007 3:21:17 Pim Zandbergen wrote:
> Jesse Barnes wrote:
> > Thanks for testing, Pim.  Glad it works for you.
>
> The pleasure was all on my side.
>
> > Keep an eye out for BIOS upgrades, the next version might fix it.
>
> What, are you going to report this to GigaByte?

No, but you should if you haven't already.  I think GigaByte probably 
gets its BIOS from another BIOS vendor (maybe Intel), so when that 
vendor provides them with an update, they'll probably provide it on 
their website.  And from what I understand, an Intel BIOS update is in 
the works to address this issue for Intel boards, so a GigaByte version 
may follow shortly.  I don't have an exact timeframe though...

Jesse

