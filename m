Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbXIYTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbXIYTkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXIYTkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:40:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35437 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXIYTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:40:45 -0400
Date: Tue, 25 Sep 2007 12:38:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rdunlap@xenotime.net, neilb@suse.de, trond.myklebust@fys.uio.no,
       sfrench@samba.org
Subject: Re: [patch 2/2] menuconfig: transform Network Filesystems menu
Message-Id: <20070925123847.2029f099.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0709250132300.23305@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709250128510.23305@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709250132300.23305@fbirervta.pbzchgretzou.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 10:10:19 +0200 (CEST) Jan Engelhardt wrote:

> 
> Turn Network File Systems into a menuconfig so that it can be
> disabled at once.
> 
> (Note: I added a "default y". If you do not like that, speak up.)
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  fs/Kconfig |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)


---
~Randy
Phaedrus says that Quality is about caring.
