Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282Ab0A0Php@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0A0Php (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459Ab0A0Php
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:37:45 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:32800 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab0A0Pho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:37:44 -0500
Date: Wed, 27 Jan 2010 16:37:41 +0100
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
Message-ID: <20100127153741.GA26011@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at> <1263576588.2751.455.camel@rc-desk> <20100119054715.GA10780@gamma.logic.tuwien.ac.at> <1263979965.10275.2.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263979965.10275.2.camel@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Mi, 20 Jan 2010, Zhu Yi wrote:
> Looks like this this is the BUG_ON in skb_pull. Please try if this patch
> help? BTW, are you using swiotlb?

As said, no it does not help.

I am currently running 2.6.33-rc5 and that bug is in my work place
100% reproducible.

Anything I can do more?

Should we move that to a bugzilla entry?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CAMER (n.)
A mis-tossed caber.
			--- Douglas Adams, The Meaning of Liff
