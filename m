Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYA2I7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYA2I7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 03:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYA2I7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 03:59:30 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33753 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYA2I73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 03:59:29 -0500
Date: Tue, 29 Jan 2008 01:06:19 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [0/2] make the early_node_mem align really for node0
To: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Message-id: <200801290106.20053.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It make the NODE_DATA aligned to ZONE_ALIGN for node0.

fix oops with 64g and 128 system

YH
