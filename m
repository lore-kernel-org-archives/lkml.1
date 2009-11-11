Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZKKREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZKKREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZKKREU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:04:20 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:49228 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZKKRET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:04:19 -0500
Date: Wed, 11 Nov 2009 09:04:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lud <linux-usb@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 2 (usb/whci)
Message-Id: <20091111090403.5fb0229e.randy.dunlap@oracle.com>
In-Reply-To: <20091102091339.479a3ddb.randy.dunlap@oracle.com>
References: <20091102173845.210d1c57.sfr@canb.auug.org.au>
	<20091102091339.479a3ddb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AFAEE91.016B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 09:13:39 -0800 Randy Dunlap wrote:

> On Mon, 2 Nov 2009 17:38:45 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20091030: <<<<<<<<<<<<<<<<<<<<<<<<<<
> 
> 
> whci build fails on i386 due to 64-bit multiply & divide:
> 
> ERROR: "__udivdi3" [drivers/usb/host/whci/whci-hcd.ko] undefined!
> ERROR: "__umoddi3" [drivers/usb/host/whci/whci-hcd.ko] undefined!


Still present in linux-next-20091111.

---
~Randy
