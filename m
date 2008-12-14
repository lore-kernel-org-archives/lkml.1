Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYLNWmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYLNWmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYLNWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:42:13 -0500
Received: from tundra.namei.org ([65.99.196.166]:1684 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbYLNWmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:42:13 -0500
Date: Mon, 15 Dec 2008 09:40:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, Christoph Hellwig <hch@infradead.org>,
       zbr@ioremap.net, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH -v4 14/14] shit on top for debugging
In-Reply-To: <20081212215228.27112.72672.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.1.10.0812150938120.7708@tundra.namei.org>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215228.27112.72672.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Eric Paris wrote:

> 

Given that this code will probably need some general debugging, perhaps 
use pr_debug.

-- 
James Morris
<jmorris@namei.org>
