Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZBJQKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZBJQKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZBJQK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:10:27 -0500
Received: from cmpxchg.org ([85.214.51.133]:52926 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBJQK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:10:27 -0500
Date: Tue, 10 Feb 2009 17:09:53 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: MinChan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: initialize sc->nr_reclaimed properly take2
Message-ID: <20090210160952.GA2371@cmpxchg.org>
References: <20090210213502.7007.KOSAKI.MOTOHIRO@jp.fujitsu.com> <28c262360902100440v765d3f7bnd56cc4b5510349c0@mail.gmail.com> <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 09:58:04PM +0900, KOSAKI Motohiro wrote:
> 
> How about this?

I agree, this is the better solution.

Thank you, Kosaki-san.

	Hannes
