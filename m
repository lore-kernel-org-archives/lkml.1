Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYKRT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYKRT0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 14:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYKRT02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 14:26:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49659 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYKRT02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:26:28 -0500
Date: Tue, 18 Nov 2008 19:26:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: fix undeclared variables
Message-ID: <20081118192626.GU28946@ZenIV.linux.org.uk>
References: <20081118174250.GE3185@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118174250.GE3185@hack.voiplan.pt>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 05:42:51PM +0000, Am??rico Wang wrote:
> 
> Fix three compile errors about undeclared variables in
> arch/um/kernel/mem.c.

And what, pray tell, would initialize it?
