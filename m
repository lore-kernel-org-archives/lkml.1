Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYJGQxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYJGQxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYJGQxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:53:39 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:51553 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYJGQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:53:38 -0400
Message-ID: <48EB93C7.6040408@fr.ibm.com>
Date: Tue, 07 Oct 2008 18:52:23 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Ryden <markryde@gmail.com>
CC: Benjamin Thery <benjamin.thery@bull.net>,
       David Shwatrz <dshwatrz@gmail.com>, Greg KH <gregkh@suse.de>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/8] sysfs: Implement sysfs tagged directory support.
References: <m18wwiihbn.fsf_-_@frodo.ebiederm.org> <20080820021754.GA25182@kroah.com>  <m1od3m282j.fsf_-_@frodo.ebiederm.org> <m1hc9e27ya.fsf_-_@frodo.ebiederm.org> <48B57058.9000101@bull.net> <dac45060809020654g62afb3c9yd104682b93b43bee@mail.gmail.com> <48BD47A8.1080909@bull.net> <20080902170148.GA9305@suse.de> <31436f4a0809032233r2c46de8od8a94460ce3b5ed2@mail.gmail.com> <48BF83E1.5040000@bull.net> <dac45060810070939v80918a0m3963d7fc6fcbb975@mail.gmail.com>
In-Reply-To: <dac45060810070939v80918a0m3963d7fc6fcbb975@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Ryden wrote:
> Hello,
>   So I wonder: the sysfs tagged directory support patch is in GerKH
> tree for more than a month.
> I cloned today latest Linus tree (2.6.27-rc9) and
> it is not there as far as I can see.
> It is also not in linux-next tree (from september).
> Now, I wonder what is the process of merging this
> GregKH tree ? should I watch the LKML list for a pull request
> from GregKH? or will it be first merged into the linux-next tree?

They have been dropped.

http://marc.info/?l=linux-kernel&m=122318517411596&w=2
