Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab0BXXHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 18:07:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181Ab0BXXHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:07:46 -0500
Date: Wed, 24 Feb 2010 15:06:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: venkatesh.pallipadi@intel.com
Cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>, Eric Paris <eparis@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] ext4: Fixup rb_root initializations to use RB_ROOT
Message-Id: <20100224150659.ecd49595.akpm@linux-foundation.org>
In-Reply-To: <20100224013921.629217000@intel.com>
References: <20100224013858.506388000@intel.com>
	<20100224013921.629217000@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 17:38:59 -0800 venkatesh.pallipadi@intel.com wrote:

> The problem with this is that 17d9ddc72fb8bba0d4f678 in the
> linux-next tree

Please don't quote bare commit ID's in changelogs.  Especially when
it's a linux-next commit: linux-next gets rebuilt each day!

The preferred form is to quote the title as well:
17d9ddc72fb8bba0d4f678 ("rbtree: Add support for augmented rbtrees") 
