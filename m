Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXAXUUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXAXUUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbXAXUUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:20:40 -0500
Received: from dsl081-065-125.sfo1.dsl.speakeasy.net ([64.81.65.125]:57418
	"EHLO lade.trondhjem.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbXAXUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:20:40 -0500
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 0/3] NFS Bugfixes for 2.6.20-rc5
Date: Wed, 24 Jan 2007 11:53:07 -0800
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net, sds@tycho.nsa.gov
Message-Id: <20070124195307.21259.64156.stgit@lade.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes 3 bugs in the 2.6.20-rc5 NFS client.

 - Fix Oops in rpc_call_sync()
 - Fix races in nfs_revalidate_mapping()
 - Ensure we support selinux xattrs

Cheers,
  Trond
