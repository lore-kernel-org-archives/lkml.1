Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbXFTNBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbXFTNBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbXFTNBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:01:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbXFTNBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:01:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: [perfmon] Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Date: Wed, 20 Jun 2007 15:01:02 +0200
User-Agent: KMail/1.9.6
Cc: =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, levon@movementarian.org,
       perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com, akpm@linux-foundation.org
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de> <20070620124959.GB24906@frankl.hpl.hp.com>
In-Reply-To: <20070620124959.GB24906@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201501.02582.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Once this is fixed (which is what Bjorn did), then I will agree with you.
> For this, the allocator needs to be able to probe the CPU and initialize
> its own data structures.

Ok that sounds reasonable. Please someone send a patch that does only 
that.

-Andi
