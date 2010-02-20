Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0BTPJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:09:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57792 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab0BTPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:09:39 -0500
Date: Sat, 20 Feb 2010 15:09:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] um: tell git to ignore generated files
Message-ID: <20100220150936.GP30031@ZenIV.linux.org.uk>
References: <20100220143359.GD3000@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100220143359.GD3000@hack>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 10:33:59PM +0800, Am??rico Wang wrote:
> 
> git should ignore these files, since they are generated.

> +include/shared/kern_constants.h
> +include/shared/user_constants.h

I have patches taking that to include/generated, actually
