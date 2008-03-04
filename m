Return-Path: <linux-kernel-owner+w=401wt.eu-S1765967AbYCDV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765967AbYCDV0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbYCDV0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:26:24 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:64672 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbYCDV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:26:23 -0500
Date: Tue, 4 Mar 2008 13:26:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ericvh@gmail.com
Subject: Re: 2.6.25-rc3-mm1 (9p docs)
Message-Id: <20080304132605.13d8114a.randy.dunlap@oracle.com>
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/


"make htmldocs" gives me:

  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
make[1]: *** No rule to make target `Documentation/DocBook/9p-overview.eps', needed by `Documentation/DocBook/9p.xml'.  Stop.
make: *** [htmldocs] Error 2


Are we missing the .eps and .png files?

---
~Randy
