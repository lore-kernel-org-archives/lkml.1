Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZBPC5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZBPC5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZBPC5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:57:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46909 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbZBPC5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:57:34 -0500
Date: Mon, 16 Feb 2009 02:57:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, gregkh@ZenIV.linux.org.uk,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [cgroup or VFS ?] WARNING: at fs/namespace.c:636
	mntput_no_expire+0xac/0xf2()
Message-ID: <20090216025729.GU28946@ZenIV.linux.org.uk>
References: <20090212070729.GF28946@ZenIV.linux.org.uk> <4995007D.7040101@cn.fujitsu.com> <20090213054751.GI28946@ZenIV.linux.org.uk> <49950F3D.3030704@cn.fujitsu.com> <20090213064135.GJ28946@ZenIV.linux.org.uk> <20090213071816.GK28946@ZenIV.linux.org.uk> <4995208D.8050700@cn.fujitsu.com> <4998C15C.2070203@cn.fujitsu.com> <20090216023812.GT28946@ZenIV.linux.org.uk> <4998D3A6.9010406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4998D3A6.9010406@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 10:47:02AM +0800, Li Zefan wrote:
> And here is my:
> 
> Tested-by: Li Zefan <lizf@cn.fujitsu.com>

Right...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
