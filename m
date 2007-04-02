Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbXDBQ4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbXDBQ4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbXDBQ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:56:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:51180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933822AbXDBQ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:56:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] Introduce cpuid_on_cpu() and cpuid_eax_on_cpu()
Date: Mon, 2 Apr 2007 18:55:55 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org,
       cpufreq@lists.linux.org.uk, davej@codemonkey.org.uk
References: <20070402113831.GA6785@localhost.sw.ru> <200704021410.29623.ak@suse.de> <46112D40.20508@zytor.com>
In-Reply-To: <46112D40.20508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021855.55935.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The CPUID and MSR drivers do not schedule to the target CPU; instead, on 
> hardware,

But powernow-k8 does.

-Andi
