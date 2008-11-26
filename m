Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYKZQuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYKZQuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYKZQua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:50:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47740 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbYKZQu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:50:27 -0500
Date: Wed, 26 Nov 2008 18:00:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@googlemail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 23/24] perfmon: kernel documentation
Message-ID: <20081126170053.GB6703@one.firstfloor.org>
References: <492d0c14.02225e0a.15ab.6f8e@mx.google.com> <20081126122107.GV6703@one.firstfloor.org> <492D7C55.4040909@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492D7C55.4040909@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +    There maybe other tools available for perfmon.
> > 
> > s/maybe/are/ ?
> 
> If not "are", then it at least should be changed to "may be".

AFAIK there are various users on top of PAPI, which supports perfmon last 
time I checked (at least supports some version of it)

-Andi

-- 
ak@linux.intel.com
