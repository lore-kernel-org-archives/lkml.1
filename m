Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZFLSVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZFLSVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZFLSVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:21:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZFLSVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:21:34 -0400
Message-ID: <4A329C5E.8050903@zytor.com>
Date: Fri, 12 Jun 2009 11:20:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>, pj@sgi.com
Subject: Re: [PATCH] x86: vendor reserved memory type
References: <E1MElFX-0007fY-TR@eag09.americas.sgi.com> <4A3123FF.3010803@zytor.com> <20090612133918.GA17557@sgi.com> <4A32980A.2020209@zytor.com> <4A329BCD.8070008@kernel.org>
In-Reply-To: <4A329BCD.8070008@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> then, if those entries are near TOML, and it is E820_RESERVED now, and it could not be directly mapped at first point.
> but later efi_remap will direct map it if the size is too big for runtime service.
> not sure others.
> 

I'm not sure I understand the comment?

	-hpa
