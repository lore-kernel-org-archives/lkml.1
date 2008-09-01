Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYIAS0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYIAS0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 14:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYIAS0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 14:26:02 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14596 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYIAS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 14:26:00 -0400
Date: Mon, 1 Sep 2008 11:25:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 1 (recordmcount.pl)
Message-Id: <20080901112549.9849ab39.randy.dunlap@oracle.com>
In-Reply-To: <20080901191946.4c35ffc9.sfr@canb.auug.org.au>
References: <20080901191946.4c35ffc9.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 19:19:46 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since next-20080829:

When using patch tarballs and applying that to kernel bases,
scripts/recordmcount.pl fails because it is not executable.
(Yes, I know, using the git would/should fix this.)

Is there any way to make (new) scripts executable when using
tarballs?

I'll handle it on a case-by-case basis for now.

Thanks,
---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
