Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZASKdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZASKdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbZASKc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:32:57 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:46109 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbZASKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:32:56 -0500
Date: Mon, 19 Jan 2009 11:32:48 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [linux-cifs-client] BUG: Possible cifs+IPv6-Regression
	2.6.27.4 -> 2.6.27.9
Message-ID: <20090119103248.GA28699@schleppi.birkenwald.de>
References: <20090118221329.GA12742@pest> <20090118210314.30832598@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118210314.30832598@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 09:03:14PM -0500, Jeff Layton wrote:

> How reproducible is this? Can you make it happen on every attempt?
> Is this kernel being built with CONFIG_CIFS_DFS_UPCALL=y ?

Happens every time. CIFS_DFS_UPCALL is set, yes.

> Could you email me the cifs.ko module from this kernel? I'd like to
> disassemble it and have a look at where it crashed. I may not be
> able to tell much, but it's worth a look...

Will do unicast when I'm back at my workstation at home.

Thanks,
Bernhard
