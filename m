Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbZIGMtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbZIGMtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZIGMtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:49:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZIGMtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:49:04 -0400
Subject: Re: [PATCH 1/5] debugfs - Fix mount directory of debugfs by
 default in events.txt
From: Peter Zijlstra <peterz@infradead.org>
To: leemgs1@gmail.com
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       mathieu.desnoyers@polymtl.ca, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <1252327037.2153.96.camel@centos51>
References: <1252327037.2153.96.camel@centos51>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 14:48:57 +0200
Message-Id: <1252327737.7959.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 21:37 +0900, GeunSik Lim wrote:
> 
> >From 99e8ab48d783e619329c31e8f91e4384729a2e8b Mon Sep 17 00:00:00 2001
> From: GeunSik,Lim <leemgs1@gmail.com>
> Date: Mon, 7 Sep 2009 20:34:19 +0900
> Subject: [PATCH 1/5] Fix mount directory of debugfs by default in events.txt
> 
> We need common default directory of denbugfs for consistency.
> (debugfs's default directory is /sys/kernel/debug/ by debugfs.)

I'd rather we fix that brain-dead default.

