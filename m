Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZA0QoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZA0QoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZA0QoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:44:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096AbZA0QoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:44:10 -0500
Date: Tue, 27 Jan 2009 08:43:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, coly.li@suse.de
Subject: Re: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2), v3
Message-Id: <20090127084315.6a2b30f3.akpm@linux-foundation.org>
In-Reply-To: <1233072389.3779.82.camel@norville.austin.ibm.com>
References: <4975F653.2000109@suse.de>
	<1233062766.3779.3.camel@norville.austin.ibm.com>
	<1233072389.3779.82.camel@norville.austin.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 10:06:29 -0600 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Tue, 2009-01-27 at 07:26 -0600, Dave Kleikamp wrote:
> > Andrew,
> > Please take this version of the jfs patch, rather than the one you
> > currently have in the -mm tree (fs-jfs-return-f_fsid-for-statfs2.patch).

yep, I need to go lkml fishing for this.

> ... or would you rather I handle it though the jfs tree and you drop it?

that would be preferable, thanks.
