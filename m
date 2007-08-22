Return-Path: <linux-kernel-owner+w=401wt.eu-S1764346AbXHVSFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764346AbXHVSFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759880AbXHVSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:05:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53961 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759718AbXHVSE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:04:59 -0400
Date: Wed, 22 Aug 2007 11:03:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070822110348.8fd6a937.randy.dunlap@oracle.com>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 02:06:48 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/

allyesconfig on x86_64 says:

kernel/unwind.c:1016:31: error: undefined identifier '__builtin_labs'
kernel/unwind.c:1232:25: error: undefined identifier '__builtin_labs'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
