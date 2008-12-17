Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759033AbYLQF7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbYLQF7s (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYLQF7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:59:37 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46801 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047AbYLQF7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:59:36 -0500
Date: Wed, 17 Dec 2008 00:59:25 -0500
From: Theodore Tso <tytso@mit.edu>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Eric Sandeen <sandeen@redhat.com>, adilger@sun.com,
        Li Zefan <lizf@cn.fujitsu.com>, linux-ext4@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch/BUG] (ext4) s_mb_maxs[] of ext4_sb_info is too small
	size
Message-ID: <20081217055925.GJ10590@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Yasunori Goto <y-goto@jp.fujitsu.com>,
	Eric Sandeen <sandeen@redhat.com>, adilger@sun.com,
	Li Zefan <lizf@cn.fujitsu.com>, linux-ext4@vger.kernel.org,
	Miao Xie <miaox@cn.fujitsu.com>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>
References: <20081216170409.34EA.E1E9C6FF@jp.fujitsu.com> <4947DE30.2090903@redhat.com> <20081217114124.2011.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217114124.2011.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I've added this to the ext4 patch queue and updated the
bugzilla entry.

						- Ted
