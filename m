Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXLGXMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXLGXMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbXLGXM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:12:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXLGXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:12:28 -0500
Date: Fri, 7 Dec 2007 15:11:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: vincent.fortier1@ec.gc.ca, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-Id: <20071207151113.e9841341.akpm@linux-foundation.org>
In-Reply-To: <20071207141536.1e9199dc.randy.dunlap@oracle.com>
References: <1196427774.10204.4.camel@kayak.wul.qc.ec.gc.ca>
	<20071130091239.708173db.randy.dunlap@oracle.com>
	<F1D642E5A91BC94D9504EC83AE19E6B0B8998E@ecqcmtlmail3.quebec.int.ec.gc.ca>
	<1196776021.14468.2.camel@kayak.wul.qc.ec.gc.ca>
	<20071207141536.1e9199dc.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007 14:15:36 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > Help would really be appreciated.
> 
> Let's try the last_sysfs_file (name) patch.
> I've attempted to update it for 2.6.22.14.
> Andrew, does this change in fs/sysfs/file.c look OK?

umm, yup.

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/gregkh-driver-sysfs-crash-debugging.patch

should work.
