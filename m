Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXLJXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXLJXCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXLJXCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:02:07 -0500
Received: from lixom.net ([66.141.50.11]:59349 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXLJXCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:02:06 -0500
Date: Mon, 10 Dec 2007 17:07:04 -0600
From: Olof Johansson <olof@lixom.net>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
Message-ID: <20071210230704.GA2550@lixom.net>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 04:07:14AM +0530, Balbir Singh wrote:

> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Looks good to me. Sure, it could be fleshed out to something more
generic and in common code, but this is small and simple and doesn't
bloat the kernel much as it stands, and it has value for debugging.

Acked-by: Olof Johansson <olof@lixom.net>
