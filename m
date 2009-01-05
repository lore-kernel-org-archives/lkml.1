Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZAEQkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZAEQkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZAEQj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:39:27 -0500
Received: from postel.suug.ch ([194.88.212.233]:53399 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZAEQj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:39:26 -0500
Date: Mon, 5 Jan 2009 17:12:08 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] cls_cgroup: clean up Kconfig
Message-ID: <20090105161208.GO20815@postel.suug.ch>
References: <49584AA5.9030509@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49584AA5.9030509@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> 2008-12-29 11:57
> cls_cgroup can't be compiled as a module, since it's not supported by
> cgroup.

Good catch, thanks.

Acked-by: Thomas Graf <tgraf@suug.ch>
