Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbYA2Tni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbYA2Tni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760859AbYA2Tlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:41:42 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52746 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbYA2Tlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:41:39 -0500
Date: Tue, 29 Jan 2008 11:16:55 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/4] x86_64: early_node_mem fix
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291116.57976.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches
1. add more print out for result for early_node_mem
2. round_up to PAGE_SIZE in early_node_mem
3. From Andi, add reserve_early in early_node_mem
4. increase MAX_EARLY_RES for early_node_mem

Thanks

YH
