Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbYBTQiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbYBTQiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934458AbYBTQ2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:28:00 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33655 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934451AbYBTQ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:27:58 -0500
Date: Wed, 20 Feb 2008 11:27:34 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 09/16] um: use get_personality()
Message-ID: <20080220162734.GC8828@c2.user-mode-linux.org>
References: <12035063603797-git-send-email-xiyou.wangcong@gmail.com> <12035063653559-git-send-email-xiyou.wangcong@gmail.com> <12035063741135-git-send-email-xiyou.wangcong@gmail.com> <12035063851778-git-send-email-xiyou.wangcong@gmail.com> <1203506389520-git-send-email-xiyou.wangcong@gmail.com> <12035063951960-git-send-email-xiyou.wangcong@gmail.com> <12035064031754-git-send-email-xiyou.wangcong@gmail.com> <12035064112844-git-send-email-xiyou.wangcong@gmail.com> <12035064241213-git-send-email-xiyou.wangcong@gmail.com> <12035064291055-git-send-email-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12035064291055-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 07:19:13PM +0800, WANG Cong wrote:
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Looks good - you should add some sort of changelog though.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
