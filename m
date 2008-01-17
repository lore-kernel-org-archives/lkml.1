Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYAQSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYAQSAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYAQR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:59:55 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:43223 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbYAQR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:59:53 -0500
Date: Thu, 17 Jan 2008 12:59:21 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [-mm Patch] uml: fix a building error
Message-ID: <20080117175921.GA4385@c2.user-mode-linux.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117135641.GD2693@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080117135641.GD2693@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:56:41PM +0800, WANG Cong wrote:
> 
> This patch fixes this building error:
> ...
> drivers/char/mem.c: In function ‘read_mem’:
> drivers/char/mem.c:136: error: implicit declaration of function ‘unxlate_dev_mem_ptr’
> ...
> 
> Cc: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

ACK

	Jeff

-- 
Work email - jdike at linux dot intel dot com
