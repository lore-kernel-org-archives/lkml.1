Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbXFNV0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbXFNV0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXFNV0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:26:42 -0400
Received: from outbound-mail-19.bluehost.com ([69.89.20.234]:32773 "HELO
	outbound-mail-19.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751681AbXFNV0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:26:41 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Thu, 14 Jun 2007 14:26:26 -0700
User-Agent: KMail/1.9.6
Cc: Pim Zandbergen <P.Zandbergen@macroscoop.nl>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <200706071530.51552.jesse.barnes@intel.com> <200706141418.42082.jbarnes@virtuousgeek.org> <Pine.LNX.4.64.0706141720330.28719@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706141720330.28719@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141426.26851.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 14, 2007 2:21:16 Justin Piszcz wrote:
> To Intel,
>
> When will HECI be supported via the kernel?  When it becomes
> supported, would that alter the MTRR map at all?

I *think* HECI is related to our IT remote management stuff, but I don't 
work on it.  It *may* affect the MTRR mappings, but I think it's just a 
PCI device, so I don't think enabling it will change the MTRR layout.

Arjan, do you know who's doing our AMT stuff?

Thanks,
Jesse
