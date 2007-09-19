Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXISLOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXISLOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXISLOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:14:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34899 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbXISLOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:14:14 -0400
Date: Wed, 19 Sep 2007 13:14:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070919111412.GA7250@one.firstfloor.org>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <p73myvjwri3.fsf@bingen.suse.de> <20070919110846.GC15500@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919110846.GC15500@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And yes, it's a pity there is no way to produce the long-nops there. :(

To be honest I consider it extremly unlikely you would be able
to measure a difference.

-Andi
