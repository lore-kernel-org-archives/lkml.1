Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZDDExj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZDDExj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 00:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZDDEx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 00:53:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:37158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZDDEx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 00:53:29 -0400
Date: Fri, 3 Apr 2009 21:36:28 -0700
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>
Cc: kaneshige.kenji@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: don't use global workqueue in
	sysfs_schedule_callback()
Message-ID: <20090404043627.GH6580@suse.de>
References: <20090325211136.GC30098@ldl.fc.hp.com> <20090403205234.GH27230@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403205234.GH27230@ldl.fc.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 02:52:34PM -0600, Alex Chiang wrote:
> Hi Greg,
> 
> You're probably still working through your email backlog, but
> just wanted to make sure this patch didn't get lost.

It's not lost, I'm digging through it all, and will get to it next week.

thanks,

greg k-h
