Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYKZJhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYKZJhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYKZJhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:37:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbYKZJhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:37:11 -0500
Subject: Re: [patch 01/24] perfmon: generic headers
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <7c86c4470811260054s2652e648i7ba44796bc40c424@mail.gmail.com>
References: <492d0bd6.0f345e0a.167c.3b37@mx.google.com>
	 <20081126.004609.15230324.davem@davemloft.net>
	 <7c86c4470811260054s2652e648i7ba44796bc40c424@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Nov 2008 10:36:53 +0100
Message-Id: <1227692213.4259.2879.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 09:54 +0100, stephane eranian wrote:

> I will fix that. For now, I simply reposted to get the cc: list correct.
> The script I use to mail the patches was unfortunately dropping
> the cc-list.

/me wonders why people still use home-brewn mailer scripts, quilt mail
works quite well, and even git seems to be able to mail without causing
these insanely deep threaded things, albeit with some extra effort.
