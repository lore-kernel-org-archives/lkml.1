Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZI0Iib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZI0Iib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZI0Iia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:38:30 -0400
Received: from [195.41.46.236] ([195.41.46.236]:47119 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbZI0Ii3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:38:29 -0400
Date: Sun, 27 Sep 2009 10:38:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Alek Du <alek.du@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts: use non-builtin echo for '-e'
Message-ID: <20090927083827.GB10177@merkur.ravnborg.org>
References: <20090819173854.2250758f@dxy.sh.intel.com> <20090819101955.GC5057@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819101955.GC5057@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:19:55PM +0800, Amerigo Wang wrote:
> 
> Alek reported that on Ubuntu, where dash is used, 'echo -e'
> can't work, so let's use non-builtin echo in this case.
> 
> Reported-by: Alek Du <alek.du@intel.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied.

	Sam
