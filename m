Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZC0M0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZC0M0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZC0M0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:26:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40453 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbZC0M0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:26:01 -0400
Date: Fri, 27 Mar 2009 14:25:56 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: LKML <linux-kernel@vger.kernel.org>
cc: Kyle McMartin <kyle@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: DMAR_DEFAULT_ON default inconsistency default vs description
Message-ID: <Pine.LNX.4.64.0903271417510.5904@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

defaults to Y while recommends N? That doesn't make too much sense...:

Enable DMA Remapping Devices by default (DMAR_DEFAULT_ON) [Y/n/?] (NEW) ?

Selecting this option will enable a DMAR device at boot time if
one is found. If this option is not selected, DMAR support can
be enabled by passing intel_iommu=on to the kernel. It is
recommended you say N here while the DMAR code remains
experimental.

-- 
 i.
