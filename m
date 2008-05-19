Return-Path: <linux-kernel-owner+w=401wt.eu-S1763160AbYESSme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763160AbYESSme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbYESSmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:42:15 -0400
Received: from www17.your-server.de ([213.133.104.17]:51439 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbYESSmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:42:14 -0400
Subject: Re: linux-next: Tree for May 19
From: Thomas Meyer <thomas@m3y3r.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080519174120.2083ea57.sfr@canb.auug.org.au>
References: <20080519174120.2083ea57.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=utf8
Date: Mon, 19 May 2008 20:42:00 +0200
Message-Id: <1211222520.30161.3.camel@dhcppc1>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 19.05.2008, 17:41 +1000 schrieb Stephen Rothwell:
> News:
> 	I will stop making full tar balls tomorrow unless someone screams.
> 	The LATEST file now contains the name of the version that the
> patches are based on i.e. today, LATEST-IS-next-20080519 contains "v2.6.26-rc3".
> 
> Changes since next-20080516:
> 
> New tree: bkl-removal  (this is Jonathan Corbet's tree)
> 
> Removed trees: x86-fixes, sched-fixes (I don't know where they are
> currently).
> 
> Changed trees: x86 and sched are now the new auto merged trees.
> 

Is it intentional that kernel.release is:

$ cat include/config/kernel.release 
2.6.26-rc3-next-20080519-sched-devel.git

all predecessors have had names like:
﻿2.6.26-rc2-next-20080516

greetz




