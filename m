Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbXKAAYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbXKAAYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXKAAYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:24:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42874
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbXKAAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:24:22 -0400
Date: Wed, 31 Oct 2007 17:24:21 -0700 (PDT)
Message-Id: <20071031.172421.228723187.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071101000211.970501947@sgi.com>
References: <20071101000211.970501947@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Are these patches against -mm or mainline?

I get a lot of rejects starting with patch 6 against
mainline and I really wanted to test them out on sparc64.

Thanks.
