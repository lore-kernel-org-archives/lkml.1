Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYAQIzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYAQIzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYAQIzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:55:43 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36807 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYAQIzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:55:42 -0500
To: neilb@suse.de
CC: jengelh@computergmbh.de, kzak@redhat.com, akpm@linux-foundation.org,
       miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
In-reply-to: <18318.41541.386224.301640@notabene.brown> (message from Neil
	Brown on Thu, 17 Jan 2008 11:33:09 +1100)
Subject: Re: [patch] VFS: extend /proc/mounts
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
	<20080116143051.ec488f3d.akpm@linux-foundation.org>
	<20080116234339.GG26049@petra.dvoda.cz>
	<Pine.LNX.4.64.0801170057520.31385@fbirervta.pbzchgretzou.qr> <18318.41541.386224.301640@notabene.brown>
Message-Id: <E1JFQWv-00061b-QA@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 17 Jan 2008 09:55:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hey, I just found /proc/X/mountstats.  How does this fit in to the big
> picture?

It seems to show some counters for NFS mounts, no other filesystem
uses it.  Format looks rather less nice, than /proc/X/mounts (why do
we need long english sentences under /proc?).

Miklos
