Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZECMY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZECMY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 08:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZECMYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 08:24:46 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43348 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751147AbZECMYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 08:24:45 -0400
Date: Sun, 3 May 2009 07:24:43 -0500
From: Jack Steiner <steiner@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix memory corruption in slbq
Message-ID: <20090503122443.GA25905@sgi.com>
References: <20090501004105.GA16409@sgi.com> <84144f020905030518u22c256ealb1d2511c397454e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905030518u22c256ealb1d2511c397454e3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I don't think this is needed now that commit 8804e6f ("SLQB:  fix dumb
> early allocation cache") is merged:
> 
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff_plain;h=8804e6f0001668656d4cb2a329e1a6e69e695a0f
> 
> Or do you still see the corruption with it?

No. The above patch is an equivalent ( & better) fix. for the problem.
You can ignore the patch that I sent.

--- jack
