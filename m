Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbZDCLwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbZDCLwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbZDCLwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:52:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49783 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZDCLw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:52:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Subject: Re: [PATCHv5] MTD: New ioctl calls for >4GiB device support
Date: Fri, 3 Apr 2009 13:52:02 +0200
User-Agent: KMail/1.9.9
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <a95a62fe0904021750m7fd01695q3724be49b66a82d@mail.gmail.com>
In-Reply-To: <a95a62fe0904021750m7fd01695q3724be49b66a82d@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904031352.03271.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX194O6gYrOmzZwKxP0ksDB/+WN+hQvmJ4GMqAbH
 w1OYiZ1XPieAB8jIYeDug40y/ckzLJZd3ZpAmTq7UJzH4vUxtU
 Mh9x7VQLa9jxpUja3fmyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, Kevin Cernekee wrote:
> 2) Use __u64 to store the MEMREADOOB64/MEMWRITEOOB64 user pointer, so
> that no compat_ioctl handler is needed.


Thanks for the change,

Acked-by: Arnd Bergmann <arnd@arndb.de>
