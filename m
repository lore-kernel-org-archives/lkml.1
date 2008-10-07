Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYJGQv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYJGQv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYJGQvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:51:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:46918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYJGQvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:51:46 -0400
Date: Tue, 7 Oct 2008 09:48:33 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Ryden <markryde@gmail.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       David Shwatrz <dshwatrz@gmail.com>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/8] sysfs: Implement sysfs tagged directory support.
Message-ID: <20081007164833.GA16056@suse.de>
References: <20080820021754.GA25182@kroah.com> <m1od3m282j.fsf_-_@frodo.ebiederm.org> <m1hc9e27ya.fsf_-_@frodo.ebiederm.org> <48B57058.9000101@bull.net> <dac45060809020654g62afb3c9yd104682b93b43bee@mail.gmail.com> <48BD47A8.1080909@bull.net> <20080902170148.GA9305@suse.de> <31436f4a0809032233r2c46de8od8a94460ce3b5ed2@mail.gmail.com> <48BF83E1.5040000@bull.net> <dac45060810070939v80918a0m3963d7fc6fcbb975@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dac45060810070939v80918a0m3963d7fc6fcbb975@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 06:39:04PM +0200, Mark Ryden wrote:
> Hello,
>   So I wonder: the sysfs tagged directory support patch is in GerKH
> tree for more than a month.

I dropped it from my tree 2 days ago, see the thread on lkml for why.

thanks,

greg k-h
