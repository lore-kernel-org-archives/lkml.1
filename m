Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbXK0FAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbXK0FAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXK0FAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:00:34 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:37142 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXK0FAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:00:33 -0500
Date: Tue, 27 Nov 2007 16:00:31 +1100
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: time accounting problem (powerpc only?)
Message-ID: <20071127050031.GC24243@bakeyournoodle.com>
References: <1195814816.4149.94.camel@johannes.berg> <1196094193.4149.287.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1196094193.4149.287.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 05:23:13PM +0100, Johannes Berg wrote:
> Contrary to what I claimed later in the thread, my 64-bit powerpc box
> (quad-core G5) doesn't suffer from this problem.
> 
> Does anybody have any idea? I don't even know how to debug it further.

I'll see if I can grab an appropriate machine tomorrow and have a look at
it.  I think it's just an accounting bug, which is probably my fault :)

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

