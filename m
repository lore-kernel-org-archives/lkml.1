Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZIIIjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZIIIjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZIIIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:39:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:51601 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZIIIjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:39:10 -0400
Date: Wed, 9 Sep 2009 18:38:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Add missing linux/tracehook.h #inclusions
In-Reply-To: <20090909073021.21257.61971.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.0909091838430.23322@tundra.namei.org>
References: <20090908104012.ff4bd25f.sfr@canb.auug.org.au> <20090909073021.21257.61971.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, David Howells wrote:

> Add #inclusions of linux/tracehook.h to those arch files that had the tracehook
> call for TIF_NOTIFY_RESUME added when support for that flag was added to that
> arch.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
