Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYGYR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYGYR3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYGYR3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:29:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:36114 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYGYR3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:29:32 -0400
Message-ID: <488A0D6E.8090105@windriver.com>
Date: Fri, 25 Jul 2008 12:29:18 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] kgdb: kgdboc serial_txx9 I/O module
References: <20080725.234914.41630045.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080725.234914.41630045.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2008 17:29:19.0796 (UTC) FILETIME=[F885B740:01C8EE7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> Implement the serial polling hooks for the serial_txx9 uart for use
> with kgdboc.
>
>   

Looks fine to me.

I pulled this into the kgdb-next branch, which I am working with Ralf to
merge.

Thanks,
Jason.
