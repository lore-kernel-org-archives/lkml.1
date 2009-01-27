Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZA0RbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZA0RbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZA0RbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:31:14 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58533 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZA0RbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:31:13 -0500
Subject: Re: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2), v3
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, coly.li@suse.de
In-Reply-To: <20090127084315.6a2b30f3.akpm@linux-foundation.org>
References: <4975F653.2000109@suse.de>
	 <1233062766.3779.3.camel@norville.austin.ibm.com>
	 <1233072389.3779.82.camel@norville.austin.ibm.com>
	 <20090127084315.6a2b30f3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 11:31:08 -0600
Message-Id: <1233077468.24364.1.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 08:43 -0800, Andrew Morton wrote:
> On Tue, 27 Jan 2009 10:06:29 -0600 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> 
> > On Tue, 2009-01-27 at 07:26 -0600, Dave Kleikamp wrote:
> > > Andrew,
> > > Please take this version of the jfs patch, rather than the one you
> > > currently have in the -mm tree (fs-jfs-return-f_fsid-for-statfs2.patch).
> 
> yep, I need to go lkml fishing for this.
> 
> > ... or would you rather I handle it though the jfs tree and you drop it?
> 
> that would be preferable, thanks.

Done

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

