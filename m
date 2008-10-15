Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYJOXqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYJOXqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYJOXqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:46:17 -0400
Received: from twin.jikos.cz ([213.151.79.26]:52074 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYJOXqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:46:16 -0400
Date: Thu, 16 Oct 2008 01:46:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Aioanei Rares <krnl.list@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel fails to compile 
In-Reply-To: <48F61AE2.8090005@gmail.com>
Message-ID: <alpine.LRH.1.10.0810160145500.2000@twin.jikos.cz>
References: <414861224052797@webmail58.yandex.ru> <20081015162143.GA19397@cosmic.amd.com> <48F61AE2.8090005@gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Aioanei Rares wrote:

> I did a git pull today and wanted to compile the kernel using a Debian
> Testing/Unstable .config, which you can find attached, and it fails to compile
> saying :
> fs/ocfs2/xattr.c: In function ?ocfs2_xattr_bucket_find?:
> fs/ocfs2/xattr.c:2352: error: ?OCFS2_BH_CACHED? undeclared (first use in this
> function)

This is already fixed in Linus' tree by commit 1efd47f87.

-- 
Jiri Kosina
SUSE Labs

