Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbXG1GNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbXG1GNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXG1GNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:13:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34752 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbXG1GNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:13:24 -0400
Date: Fri, 27 Jul 2007 23:17:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm/sparse.c:482: error: implicit declaration of function
 =?UTF-8?Q?=E2=80=98sparse=5Fearly=5Fusemap=5Falloc=E2=80=99?=
Message-Id: <20070727231710.0c5b52a9.randy.dunlap@oracle.com>
In-Reply-To: <a44ae5cd0707272300y85825d0v9b8ff60de0de50a0@mail.gmail.com>
References: <a44ae5cd0707272300y85825d0v9b8ff60de0de50a0@mail.gmail.com>
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

On Fri, 27 Jul 2007 23:00:54 -0700 Miles Lane wrote:

> Do you need my .config file?

Ideally, yes.  Is this for 2.6.23-rc1-mm1?


>   CC      mm/sparse.o
> mm/sparse.c: In function 'sparse_init':
> mm/sparse.c:482: error: implicit declaration of function
> 'sparse_early_usemap_alloc'
> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> make[1]: *** [mm/sparse.o] Error 1


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
