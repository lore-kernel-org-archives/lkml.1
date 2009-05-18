Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZERMMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZERMMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZERMLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:11:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:57001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZERMLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:11:54 -0400
Date: Mon, 18 May 2009 14:11:54 +0200
From: Jan Kara <jack@suse.cz>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: mtk-manpages@gmx.net, linux-kernel@vger.kernel.org
Subject: Re: quotactl ERANGE man page update
Message-ID: <20090518121153.GA25232@duck.suse.cz>
References: <f5a7b3810905160458if6ce50en5079fc7f877484ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5a7b3810905160458if6ce50en5079fc7f877484ee@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Sat 16-05-09 17:28:28, naresh kamboju wrote:
> Regarding the quota system call man page update,
> 
> I have noticed changes in recent kernels
> Linux/fs/quota/ dquot.c under function name
> static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
> ERANGE error check has been added.
> 
> So could you update the quotactl man page w.r.t if_dqblk.dqb_valid
  Thanks for reminder. I've updated manpage distributed with quota-tools
accordingly.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
