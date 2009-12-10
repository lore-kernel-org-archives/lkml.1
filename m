Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbZLJHXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbZLJHXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbZLJHXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:23:23 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52054 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbZLJHXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:23:22 -0500
Message-ID: <4B20A1EF.9080300@cs.helsinki.fi>
Date: Thu, 10 Dec 2009 09:23:27 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf kmem: Show usage if no option is specified
References: <4B20A195.8030106@cn.fujitsu.com>
In-Reply-To: <4B20A195.8030106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan kirjoitti:
> As Ingo suggested, make "perf kmem" show help information.
> "perf kmem stat [--caller] [--alloc] .." will show memory
> statistics.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
