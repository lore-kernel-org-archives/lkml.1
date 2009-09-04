Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbZIDOlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbZIDOlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbZIDOlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:41:12 -0400
Received: from fifo99.com ([67.223.236.141]:37023 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346AbZIDOlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:41:04 -0400
Subject: Re: [patch 08/33] fs: dcache scale nr_dentry
From: Daniel Walker <dwalker@fifo99.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090904065535.121108656@nick.local0.net>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.121108656@nick.local0.net>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 07:41:02 -0700
Message-Id: <1252075262.22928.9.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> plain text document attachment (fs-dcache-scale-nr_dentry.patch)
> Make dentry_stat_t.nr_dentry an atomic_t type, and move it from under
> dcache_lock.
> ---
>  fs/dcache.c            |   20 +++++++++-----------
>  include/linux/dcache.h |    4 ++--
>  kernel/sysctl.c        |    6 ++++++
>  3 files changed, 17 insertions(+), 13 deletions(-)
> 

No sign off on this one..

Daniel

