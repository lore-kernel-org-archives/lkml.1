Return-Path: <linux-kernel-owner+w=401wt.eu-S965511AbXCOMhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511AbXCOMhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXCOMhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:37:24 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:7752
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965511AbXCOMhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:37:23 -0400
Message-Id: <45F94C45.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 15 Mar 2007 12:38:13 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: PCI DAC DMA APIs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While the kernel headers provide for this, there don't appear to be any
in-tree users (which seems contrary to general Linux policies). Would there
be objections to remove all of these?

Jan
