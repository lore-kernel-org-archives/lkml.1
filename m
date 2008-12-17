Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759871AbYLQHg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbYLQHg0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLQHgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:36:15 -0500
Received: from tundra.namei.org ([65.99.196.166]:3806 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYLQHgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:36:15 -0500
Date: Wed, 17 Dec 2008 18:35:55 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/15] sanitize audit_mq_getsetattr()
In-Reply-To: <E1LCohK-0000Ai-Sw@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812171835430.22856@tundra.namei.org>
References: <E1LCohK-0000Ai-Sw@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> 
> * get rid of allocations
> * make it return void
> * don't duplicate parts of audit_dummy_context()
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
