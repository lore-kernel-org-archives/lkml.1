Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYDIXyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYDIXyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 19:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYDIXyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 19:54:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30262 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYDIXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 19:54:33 -0400
Message-ID: <47FD56FE.6070603@oracle.com>
Date: Wed, 09 Apr 2008 16:53:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       samr <sam@ravnborg.org>
Subject: Re: [PATCH v2] documentation: build source files in Documentation
 sub-dir
References: <20080403124529.3f2efb79.randy.dunlap@oracle.com> <20080408134613.a047a7b6.akpm@linux-foundation.org> <20080409123551.42c5da0d.randy.dunlap@oracle.com> <20080409225229.GC18242@tull.net>
In-Reply-To: <20080409225229.GC18242@tull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> On Wed, Apr 09, 2008 at 12:35:51PM -0700, Randy Dunlap wrote:
>> +##oops, this is a kernel module::hostprogs-y := procfs_example
> 
> Is this intentional? It looks like you commented-out a mistake.

Nope.  I have no idea where that came from.  Fixed in my patches.

Thanks.

-- 
~Randy
