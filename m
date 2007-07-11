Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbXGKFAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbXGKFAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXGKFAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:00:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49389 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbXGKFAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:00:42 -0400
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <20070710163027.1bf7e94e.akpm@linux-foundation.org>
References: <1183275416.4010.125.camel@localhost.localdomain>
	 <20070710163027.1bf7e94e.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 10 Jul 2007 22:00:41 -0400
Message-Id: <1184119241.20193.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:36:56 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > This patch is a spinoff of the old nanosecond patches.
> 
> I don't know what the "old nanosecond patches" are.  A link to a suitable
> changlog for those patches would do in a pinch.  Preferable would be to
> write a proper changelog for this patch.
> 
I found the original patch
http://marc.info/?l=linux-ext4&m=115091699809181&w=2

Andreas or Kalpak, is changelog from the original patch is accurate to
apply here?

Mingming

