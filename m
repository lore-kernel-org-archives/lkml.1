Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZBLCxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZBLCxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZBLCxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:53:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbZBLCxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:53:34 -0500
Date: Wed, 11 Feb 2009 18:53:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jan Kara <jack@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (reiser4-quota)
Message-Id: <20090211185321.138bb93a.akpm@linux-foundation.org>
In-Reply-To: <20090212114737.C8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <499305AD.4020900@oracle.com>
	<20090211171324.GC13817@duck.suse.cz>
	<20090212114737.C8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 11:49:20 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Andrew, recently I've never seen any reiser4 activity in LKML.
> I would suggest to remove it from -mm.

A handful of people use it, and the cost of carrying it is pretty low.

Hey, at least it handles ENOSPC without going BUG().
