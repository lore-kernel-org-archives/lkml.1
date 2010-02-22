Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0BVSxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:53:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0BVSxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:53:22 -0500
Date: Mon, 22 Feb 2010 13:53:16 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Roland McGrath <roland@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "parisc: HAVE_ARCH_TRACEHOOK"
Message-ID: <20100222185316.GA21734@bombadil.infradead.org>
References: <20100222184857.AA88C64C@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222184857.AA88C64C@magilla.sf.frob.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 10:48:57AM -0800, Roland McGrath wrote:
> HAVE_ARCH_TRACEHOOK requires defining the user_regset interfaces,
> including task_user_regset_view().  parisc doesn't do that yet,
> so don't lie about it.
> 

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
