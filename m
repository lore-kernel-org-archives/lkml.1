Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYDPXoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYDPXoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYDPXnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:43:53 -0400
Received: from namei.org ([69.55.235.186]:34877 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750840AbYDPXnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:43:52 -0400
Date: Thu, 17 Apr 2008 09:42:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: maximilian attems <max@stro.at>
cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Martin Michlmayr <tbm@cyrius.com>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: [PATCH] Kconfig: enhance DEFAULT_MMAP_MIN_ADDR description
In-Reply-To: <20080416173636.GB19260@stro.at>
Message-ID: <Xine.LNX.4.64.0804170942190.5613@us.intercode.com.au>
References: <1208366024-20261-1-git-send-email-max@stro.at>
 <1208366589.12707.10.camel@localhost.localdomain> <20080416173636.GB19260@stro.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008, maximilian attems wrote:

> Got burned by setting the proposed default of 65536
> across all Debian archs.
> 
> Thus proposing to be more specific on which archs you may
> set this. Also propose a value for arm and friends that
> doesn't break sshd.
> 
> Reword to mention working archs ia64 and ppc64 too.
> 
> Signed-off-by: maximilian attems <max@stro.at>
> Cc: Martin Michlmayr <tbm@cyrius.com>
> Cc: Gordon Farquharson <gordonfarquharson@gmail.com>
> Acked-by: Eric Paris <eparis@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


-- 
James Morris
<jmorris@namei.org>
