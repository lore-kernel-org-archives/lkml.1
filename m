Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998Ab0ANQII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0ANQII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 11:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439Ab0ANQIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 11:08:07 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:37277 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0ANQIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 11:08:06 -0500
Date: Thu, 14 Jan 2010 08:07:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-13-12-17 uploaded (cgroup)
Message-Id: <20100114080748.4eaf91d6.randy.dunlap@oracle.com>
In-Reply-To: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B4F4158.00B7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 12:17:36 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-01-13-12-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git


patch:  cgroups-subsystem-module-unloading.patch

When CONFIG_MODULE_UNLOAD is not enabled:

kernel/cgroup.c:1013: error: implicit declaration of function 'module_refcount'



---
~Randy
