Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbYHEPhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbYHEPhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbYHEPhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:37:43 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54065 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYHEPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:37:42 -0400
Message-ID: <4898738B.60608@s5r6.in-berlin.de>
Date: Tue, 05 Aug 2008 17:36:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1-git5 6/26] mdb: fix ScreenInputFromKeyBoard,
 add Alternate Debugger Interface
References: <200808050626.m756QZ1a003763@wolfmountaingroup.com>
In-Reply-To: <200808050626.m756QZ1a003763@wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> --- a/debug/mdb.c	1969-12-31 17:00:00.000000000 -0700
> +++ b/debug/mdb.c	2008-08-04 17:00:17.000000000 -0600
...
> +*   This program is free software; you can redistribute it and/or modify it
> +*   under the terms of the GNU General Public License as published by the
> +*   Free Software Foundation, version 2, or any later version.

In other files you have:

> +*   This program is free software; you can redistribute it and/or modify it
> +*   under the terms of the GNU General Public License as published by the
> +*   Free Software Foundation, version 2.

The kernel as a whole is indeed licensed under GPLv2 without "or later"
clause, but certain parts can be (and are) licensed under alternative
terms too.  I don't know how mdb fits into the picture, but since it is
a port from other systems it seems to be of the kind which could have
alternative terms (as long as GPLv2 is one of the options).  But don't
take my word for it.
-- 
Stefan Richter
-=====-==--- =--- --=-=
http://arcgraph.de/sr/
