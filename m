Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbZAEQjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbZAEQjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZAEQjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:39:24 -0500
Received: from postel.suug.ch ([194.88.212.233]:53289 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZAEQjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:39:24 -0500
X-Greylist: delayed 1724 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2009 11:39:23 EST
Date: Mon, 5 Jan 2009 17:11:48 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] cls_cgroup: clean up for cgroup part
Message-ID: <20090105161148.GN20815@postel.suug.ch>
References: <49584AA2.4010506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49584AA2.4010506@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> 2008-12-29 11:57
> - It's better to use container_of() instead of casting cgroup_subsys_state *
>   to cgroup_cls_state *.
> - Add helper function task_cls_state().
> - Rename net_cls_state() to cgrp_cls_state().

A bit pointless but does not hurt anyone.

Acked-by: Thomas Graf <tgraf@suug.ch>
