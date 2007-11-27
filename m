Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbXK0AGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbXK0AGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbXK0AGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:06:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbXK0AGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:06:39 -0500
Message-ID: <474B5F73.1090407@redhat.com>
Date: Mon, 26 Nov 2007 19:06:11 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.14
References: <20071121175644.GA1329@kroah.com>	 <20071121175701.GB1329@kroah.com> <1196000495.18901.8.camel@sven.thebigcorporation.com>
In-Reply-To: <1196000495.18901.8.camel@sven.thebigcorporation.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2007 09:21 AM, Sven-Thorsten Dietrich wrote:
> Hi Greg,
> 
> I think this hunk in the 2.6.22.14 stable patch may be a mis-patch --
> compared to Linus's current git -- the new code should be inserted below
> the while loop that follows.
> 

patch looks fine to me.

> Also see commit 9f96cb1e8bca179a92afa40dfc3c49990f1cfc71
> 

But this one does rearrange things quite a bit and is not included. That
is why things look out of order compared to current git.
