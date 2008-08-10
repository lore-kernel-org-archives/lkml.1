Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYHJBCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYHJBCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 21:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYHJBCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 21:02:10 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37281 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYHJBCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 21:02:10 -0400
Date: Sat, 9 Aug 2008 19:01:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 3/3] PCI: Add pci_read_base() API
Message-ID: <20080810010153.GM8618@parisc-linux.org>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-4-git-send-email-matthew@wil.cx> <20080804063833.GA21354@colo.lackof.org> <20080806143844.GL2055@parisc-linux.org> <20080810004750.GA2617@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810004750.GA2617@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 06:47:50PM -0600, Grant Grundler wrote:
> This would be a suitable comment in the code.
> My point still stands: The next person modifying the code will
> need to know how/what to test and where to look it up.

It turns out Eric doesn't need this code after all.  So we have no
users, and this patch (3/3) isn't going into the tree.  1/3 and 2/3
are already in, and make the code easier to follow while adding no
additional functionality.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
