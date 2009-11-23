Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZKWNTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZKWNTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZKWNTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:19:33 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:58087 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbZKWNTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:19:33 -0500
Date: Mon, 23 Nov 2009 13:19:32 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org
Subject: Re: linux-next: Tree for November 23
Message-ID: <20091123131932.GA28687@linux-mips.org>
References: <20091123185232.1423c56b.sfr@canb.auug.org.au> <4B0A8841.8090905@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0A8841.8090905@petalogix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 02:04:01PM +0100, Michal Simek wrote:

>> The microblaze tree still has a build failure for which I reverted a
>> commit.
>>
>> The mips tree gained a conflict against the microblaze tree.
>
> It is problem which is caused one my ftrace patch. MIPS ftrace  
> implementation was first that's why I should solve it. It is easy to fix.
> I just need to know where mips/mips-for-linux-next branch is.

Gitweb:  http://www.linux-mips.org/git?p=upstream-sfr.git;a=summary
Git:     git://www.linux-mips.org/pub/scm/upstream-sfr.git

  Ralf 
