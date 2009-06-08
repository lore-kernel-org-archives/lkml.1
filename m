Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZFHRTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZFHRTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZFHRTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:19:42 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57129 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750894AbZFHRTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:19:42 -0400
Message-Id: <20090608171648.988318000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:48 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 00/12] GRU - GRU Driver Updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is a collection of patches to the GRU driver.
All changes are internal to the driver and have no effect
on the core kernel or interfaces to/from the core kernel.

Thiese patches must be applied on TOP of the patches that
already exist in the -mm tree.

Patches were built against linux-next of 6/8/2009.

