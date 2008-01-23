Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYAWLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYAWLPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYAWLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:15:45 -0500
Received: from mx1.suse.de ([195.135.220.2]:58573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYAWLPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:15:45 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86 II
Date: Wed, 23 Jan 2008 12:15:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <200801231145.14915.andi@firstfloor.org> <20080123105757.GE21455@csn.ul.ie>
In-Reply-To: <20080123105757.GE21455@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231215.56741.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Anyways from your earlier comments it sounds like you're trying to add SRAT 
parsing to CONFIG_NUMAQ. Since that's redundant with the old implementation
it doesn't sound like a very useful thing to do.

But the patch is applied already i think. Well I'm sure it passed 
checkpatch.pl at least.

-Andi


