Return-Path: <linux-kernel-owner+w=401wt.eu-S935404AbXGWUWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404AbXGWUWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934631AbXGWUUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:20:20 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42714 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764720AbXGWUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:20:10 -0400
Date: Mon, 23 Jul 2007 13:22:19 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/10] numa_node and apicid_to_node clean up
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <"Christoph Lameter"@Sun.COM>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <"Christoph Hellwig"@Sun.COM>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707231322.19655.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

it is releated to acpi=off or SRAT/_PXM is not defined case.

Thanks

YH
