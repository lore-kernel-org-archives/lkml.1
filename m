Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752874AbYLRRWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbYLRRWZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYLRRWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:22:14 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:55459 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYLRRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:22:13 -0500
Date: Thu, 18 Dec 2008 09:21:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dhowells@redhat.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 18 (slow-work)
Message-Id: <20081218092145.7e1566ef.randy.dunlap@oracle.com>
In-Reply-To: <20081218230637.c879a046.sfr@canb.auug.org.au>
References: <20081218230637.c879a046.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.494A86AD.0009:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when CONFIG_SYSCTL=n:

build-r7380.out:/local/linsrc/linux-next-20081218/kernel/slow-work.c:612: error: 'slow_work_max_max_threads' undeclared (first use in this function)
build-r7380.out:make[2]: *** [kernel/slow-work.o] Error 1


---
~Randy
