Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZBPXhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZBPXhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZBPXhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:37:39 -0500
Received: from ozlabs.org ([203.10.76.45]:59203 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZBPXhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:37:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
Date: Tue, 17 Feb 2009 10:07:27 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <200902162040.44178.rusty@rustcorp.com.au> <20090216175907.GA4582@nowhere>
In-Reply-To: <20090216175907.GA4582@nowhere>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171007.28257.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 04:29:08 Frederic Weisbecker wrote:
> Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> And also, Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Thanks, done, and I'll send to Linus and -stable immediately.

> Just one last little thing, it would be good to strip the ending newline
> while using echo without -n

Agreed, but fixing that is much less urgent.  (It also effects "string"
module parameters).

Thanks!
Rusty.
