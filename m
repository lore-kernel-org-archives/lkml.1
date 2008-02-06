Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbYBFGuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbYBFGuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYBFGu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:50:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37586 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYBFGuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:50:10 -0500
Date: Wed, 06 Feb 2008 15:49:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't works on memoryless node.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       torvalds@linux-foundation.org, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <1202248652.5332.51.camel@localhost>
References: <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1202248652.5332.51.camel@localhost>
Message-Id: <20080206154716.2723.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee-san

> Here's a patch that addresses the problem w/o requiring change to
> numactl or libnuma.  It DOES have side affects, discussed in the
> description.

Thank you!

but unfortunately, My machine is broken phisically today ;-)
I will test it tommorow or later.



