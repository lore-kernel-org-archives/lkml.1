Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYAWLLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYAWLLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYAWLLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:11:34 -0500
Received: from ns.suse.de ([195.135.220.2]:57767 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYAWLLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:11:34 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Date: Wed, 23 Jan 2008 12:11:43 +0100
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
Message-Id: <200801231211.43637.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I was pretty sure that a !NUMAQ i386 CONFIG_NUMA build
> > already used that.
>
> Presumably a GENERICARCH configuration

GENERICARCH includes SUMMIT so yes.

> > At least that was the case when I last looked. If that
> > has changed it must have bitrotted recently.
>
> I don't think it has bit-rotted. I was just not using a GENERICARCH
> configuration.

And no SUMMIT either?  Ok you already answered that later.

-Andi
