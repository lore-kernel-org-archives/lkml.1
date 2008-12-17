Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760310AbYLQHnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYLQHnl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYLQHn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:43:28 -0500
Received: from tundra.namei.org ([65.99.196.166]:2865 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759047AbYLQHn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:43:27 -0500
Date: Wed, 17 Dec 2008 18:42:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/15] sanitize audit_fd_pair()
In-Reply-To: <E1LCohy-0000De-Tc@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812171842170.22856@tundra.namei.org>
References: <E1LCohy-0000De-Tc@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> 
> * no allocations
> * return void
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
