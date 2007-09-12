Return-Path: <linux-kernel-owner+w=401wt.eu-S1764117AbXILIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764117AbXILIfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXILIfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:35:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbXILIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:35:23 -0400
Date: Wed, 12 Sep 2007 01:35:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] Extract the file descriptor search logic in SPU
 coredump code
Message-Id: <20070912013513.08678a30.akpm@linux-foundation.org>
In-Reply-To: <200709121817.43263.jk@ozlabs.org>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
	<200709121817.43263.jk@ozlabs.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 18:17:42 +1000 Jeremy Kerr <jk@ozlabs.org> wrote:

> This series looks good to me, thanks for the fixes. I'll do some testing 
> tomorrow but it looks like it'll be fine as-is.
> 
> Andrew - almost all of these are for spufs, the notable exception being:
> 
>  [PATCH 12/15] Cleanup ELF coredump extra notes logic
> 
> which touches the generic elf/coredump path.
> 
> Are you ok for me to merge this to my spufs tree, and upstream via 
> paulus?

Sure.  I'd only get in the way with spufs stuff.
