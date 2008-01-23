Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYAWWGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYAWWGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYAWWFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:05:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYAWWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:05:54 -0500
Date: Wed, 23 Jan 2008 14:05:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       mark.fasheh@oracle.com
Subject: Re: [PATCH 08/30] ocfs2: Readpages support
Message-Id: <20080123140541.473cf034.akpm@linux-foundation.org>
In-Reply-To: <1200609356-17788-9-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-9-git-send-email-mark.fasheh@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Jan 2008 14:35:34 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> Add ->readpages support to Ocfs2. This is rather trivial - all it required
> is a small update to ocfs2_get_block (for mapping full extents via b_size)
> and an ocfs2_readpages() function which partially mirrors ocfs2_readpage().
> 

Was there any performance improvement?

> + * siutations are safe to ignore.

Cnat tpye.

