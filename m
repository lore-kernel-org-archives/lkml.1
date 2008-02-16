Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbYBPU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbYBPU3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYBPU3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:29:08 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46517 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYBPU3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:29:07 -0500
Message-id: <098123kjff90231nv098233rnvd908u234@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Fri, 15 Feb 2008 23:41:15 -0500
Subject: [PATCH 00/14] [ISDN] convert HiSax to hotplug APIs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next revision of the ISDN hotplug conversion patches.

Changes since last version:
- handled ml comments
- checkpatch fixes
- moved proto.h addition into correct changeset
- separated some bug fixes out from the diva changeset, into
  their own changeset.

Work remaining:

- convert elsa
- convert sedlbauer
- test
- address akpm's problem report?


