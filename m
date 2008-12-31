Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYLaL33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYLaL33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbYLaL3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:29:18 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:35696 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbYLaL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:29:17 -0500
Subject: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 06:28:55 -0500
Message-Id: <1230722935.4680.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.495B5780.000F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I've done some testing against Linus' git tree from last night and the
current btrfs trees still work well.

There are a few bug fixes that I need to include from while I was on
vacation but I haven't made any large changes since early in December:

Btrfs details and usage information can be found:

http://btrfs.wiki.kernel.org/

The btrfs kernel code is here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary

And the utilities are here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris


