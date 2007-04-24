Return-Path: <linux-kernel-owner+w=401wt.eu-S1422808AbXDXReJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbXDXReJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422824AbXDXReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:34:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422808AbXDXReE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:34:04 -0400
Date: Tue, 24 Apr 2007 10:33:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Vincent Vanackere <vincent.vanackere@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [OOPS 2.6.21-rc7-mm1] kernel BUG at fs/sysfs/inode.c:272
 (sysfs_drop_dentry)
Message-Id: <20070424103358.3be9efcd.akpm@linux-foundation.org>
In-Reply-To: <462E3177.4000901@gmail.com>
References: <65258a580704240820lbee4944t1adef1aeb92394ce@mail.gmail.com>
	<462E3177.4000901@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 01:33:59 +0900 Tejun Heo <htejun@gmail.com> wrote:

> Vincent Vanackere wrote:
> > Hi,
> > 
> > I'm getting the following oops at boot with the latest -mm kernel :
> > ---------------------------------------------------------------
> > kernel BUG at fs/sysfs/inode.c:272
> 
> Known problem.  Working on it.  Thanks.
> 

If it had been known by me I wouldn't have released known-buggy code to
people who need to be able to test other people's code too. (argh)

