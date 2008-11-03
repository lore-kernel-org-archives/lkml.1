Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYKCVh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYKCVh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYKCVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:37:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882AbYKCVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:37:45 -0500
Date: Mon, 3 Nov 2008 13:37:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: David.Woodhouse@intel.com, g.chen@freescale.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Michael.Hennerich@analog.com
Subject: Re: [PATCH] m25p80: fix detection of m25p16 flashes
Message-Id: <20081103133722.56bcf9a1.akpm@linux-foundation.org>
In-Reply-To: <1225396786-23679-1-git-send-email-vapier@gentoo.org>
References: <1225286467-17955-1-git-send-email-vapier@gentoo.org>
	<1225396786-23679-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 15:59:46 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> Commit d0e8c47c58575b9131e786edb488fd029eba443e added support for extended ids

Quoting a bare hash in the changelog is a bit reader-hostile and I
believe there's some git-related issue which can cause people to not be
able to find the commit at all (I'm not sure what the circumstances
are, but Linus has mentioned it a couple of times when asking people to
not quote bare commit IDs in changelogs).

So when referencing a previous commit please use this form:

   Commit d0e8c47c58575b9131e786edb488fd029eba443e ("m25p80.c
   extended jedec support").

Thanks.
