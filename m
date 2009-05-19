Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZESPSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZESPSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZESPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:18:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbZESPSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:18:15 -0400
Date: Tue, 19 May 2009 17:18:15 +0200
From: Jan Kara <jack@suse.cz>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: Jan Kara <jack@suse.cz>, mtk-manpages@gmx.net,
       linux-kernel@vger.kernel.org
Subject: Re: quotactl ERANGE man page update
Message-ID: <20090519151815.GD28289@duck.suse.cz>
References: <f5a7b3810905160458if6ce50en5079fc7f877484ee@mail.gmail.com> <20090518121153.GA25232@duck.suse.cz> <f5a7b3810905190327r2cfa84feka3abb3f57c5b24bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5a7b3810905190327r2cfa84feka3abb3f57c5b24bc@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-05-09 15:57:48, naresh kamboju wrote:
> Hi,
> 
> >> So could you update the quotactl man page w.r.t if_dqblk.dqb_valid
> >  Thanks for reminder. I've updated manpage distributed with quota-tools
> > accordingly.
> > --
> > Jan Kara <jack@suse.cz>
> 
> Thanks for your update.
> May I know when history-header-section of files will be modified?
> (fs/quota/dquot.c)
  Probably never. We use changelogs in git now.

> Is there any modification in Documentation-section
> required?(Documentation/filesystems/quota.txt)
  No, because it documents just netlink interface. The rest is either in
quota tools documentation or in man pages.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
