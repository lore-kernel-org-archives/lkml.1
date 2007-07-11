Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbXGKGT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbXGKGT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbXGKGTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:19:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756507AbXGKGTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:19:16 -0400
Date: Tue, 10 Jul 2007 23:18:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 9][PATCH
 4/5]Morecleanups:ext4_extent_compilation_fixes
Message-Id: <20070710231837.2848ab83.akpm@linux-foundation.org>
In-Reply-To: <1183275531.4010.140.camel@localhost.localdomain>
References: <1183275531.4010.140.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:38:51 -0400 Mingming Cao <cmm@us.ibm.com> wrote:

> Subject: [EXT4 set 9][PATCH 4/5]Morecleanups:ext4_extent_compilation_fixes
> Date: 	Sun, 01 Jul 2007 03:38:51 -0400
> Sender: linux-kernel-owner@vger.kernel.org
> Organization: IBM Linux Technology Center
> X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
> 
> From: Dmitry Monakhov <dmonakhov@sw.ru>
> Subject: ext4: extent compilation fixes

I hope this patch series will hit git with nice titles like "ext4: extent
compilation fixes" and not funny ones like
"Morecleanups:ext4_extent_compilation_fixes".

> Fix compilation with EXT_DEBUG, also fix leXX_to_cpu convertions.

"conversions".
