Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYDONe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYDONe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbYDONeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:34:18 -0400
Received: from [198.99.130.12] ([198.99.130.12]:56833 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbYDONeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:34:17 -0400
Date: Tue, 15 Apr 2008 09:33:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: Clean up arch/um/drivers/ubd_kern.c
Message-ID: <20080415133325.GA7882@c2.user-mode-linux.org>
References: <20080413.005559.143852921.xiyou.wangcong@gmail.com> <20080414234237.48ac4609.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414234237.48ac4609.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:42:37PM -0700, Andrew Morton wrote:
> omg, when checkpatch bit into this patch my CPU melted.

Yeah, I've been scared to do a checkpatch run over that file.  I think
it's the only core file left in UML which hasn't been tidied.  Sorry.

Drop this one, and I'll send a another one which at least is tidied up
around the changed areas.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
