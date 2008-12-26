Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYLZGe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYLZGe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLZGev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 01:34:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52547 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYLZGeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 01:34:50 -0500
Date: Fri, 26 Dec 2008 06:34:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, ttb@tentacle.dhs.org, rml@novell.com,
       kosaki.motohiro@jp.fujitsu.com, zbr@ioremap.net
Subject: Re: [PATCH] filesystem notification: create fs/notify to contain
	all fs notification
Message-ID: <20081226063441.GV28946@ZenIV.linux.org.uk>
References: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com> <20081217150613.bf787435.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217150613.bf787435.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 03:06:13PM -0800, Andrew Morton wrote:

> git does a good job of this and perhaps we can persuade Al to carry
> this patch in the vfs tree.

In queue, actually...

Al, very much hoping to finish that crap by the weekend.
