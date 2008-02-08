Return-Path: <linux-kernel-owner+w=401wt.eu-S935149AbYBHSGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149AbYBHSGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbYBHSA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:00:26 -0500
Received: from flpi102.sbcis.sbc.com ([207.115.20.71]:20279 "EHLO
	flpi102.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbYBHSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:00:20 -0500
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 00/11] RFC: Kconfig changes for NFS_FS and NFSD
To: linux-kernel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org
Date: Fri, 08 Feb 2008 12:51:24 -0500
Message-ID: <20080208174437.16261.60381.stgit@manray.1015granger.net>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scratching my head to find an appropriate mailing list for review of some
proposed NFS-related Kconfig changes.  These have already seen some light
on linux-nfs, but Herbert Xu suggested lkml for review by Kconfig experts.

In addition to updating the help text, I've tried to untangle the entry
dependencies somewhat.  I'm not really a Kconfig expert, so I'd appreciate
some review of these patches by those more knowlegeable than me.

-- 
corporate:    <chuck dot lever at oracle dot com>
