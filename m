Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZDNPX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZDNPX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZDNPXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:23:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60264 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZDNPXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:23:16 -0400
Date: Tue, 14 Apr 2009 17:21:22 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Message-ID: <20090414152122.GA2299@random.random>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <200904150026.36142.nickpiggin@yahoo.com.au> <20090414143252.GE28265@random.random> <200904150042.15653.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904150042.15653.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 12:42:14AM +1000, Nick Piggin wrote:
> to waste their time [..]

Me neither.

> If we get that far, then I can ask them to run tests definitely.

Agreed!
