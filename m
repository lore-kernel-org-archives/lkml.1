Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173Ab0AZV3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0AZV3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563Ab0AZV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:29:08 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35398 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0AZV3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:29:07 -0500
Date: Tue, 26 Jan 2010 15:29:04 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
       cl@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix unmap_vma() bug related to mmu_notifiers
Message-ID: <20100126212904.GE6653@sgi.com>
References: <20100125174556.GA23003@sgi.com>
 <20100125190052.GF5756@random.random>
 <20100125211033.GA24272@sgi.com>
 <20100125211615.GH5756@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125211615.GH5756@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 10:16:15PM +0100, Andrea Arcangeli wrote:
> The old patches are in my ftp area, they should still apply, you
> should concentrate testing with those additional ones applied, then it
> will work for xpmem too ;)

Andrea, could you point me at your ftp area?

Thanks,
Robin
