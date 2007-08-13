Return-Path: <linux-kernel-owner+w=401wt.eu-S1031976AbXHMQu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031976AbXHMQu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947387AbXHMQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:14:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3099 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938075AbXHMQOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:14:38 -0400
Subject: Re: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
From: Joe Perches <joe@perches.com>
To: Theodore Tso <tytso@mit.edu>
Cc: torvalds@linux-foundation.org, sct@redhat.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       akpm@linux-foundation.org, Eric Sandeen <esandeen@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <20070813151917.GA28130@thunk.org>
References: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com>
	 <20070813090128.GJ6689@schatzie.adilger.int>
	 <20070813151917.GA28130@thunk.org>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 09:14:01 -0700
Message-Id: <1187021641.10249.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 11:19 -0400, Theodore Tso wrote:
> Yep, agreed.

OK. saved in my tree as

EXT4 FILE SYSTEM
P:      Ted Ts'o
M:	tytso@mit.edu
P:	Eric Sandeen
M:	sandeen@sgi.com
P:	Mingming Cao
M:	cmm@us.ibm.com
L:	linux-ext4@vger.kernel.org
S:	Maintained
F:	fs/ext4/
F:	include/linux/ext4*

Separate question.  Is it right that the L: entries
for ext2/3/4 are all linux-ext4@vger.kernel.org?

