Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZA1N57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZA1N57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZA1N51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:47066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbZA1N50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:26 -0500
Message-Id: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:53:52 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: [PATCH 00/21] lockdep: pending queue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick's reclaim recursion patch and my cleanup series.
-- 

