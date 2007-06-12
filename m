Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbXFLNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbXFLNI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbXFLNHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:07:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43759 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbXFLNHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:07:31 -0400
Message-Id: <20070612121351.448814658@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 12 Jun 2007 14:13:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 0/4] lockstat updates
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Biggest among these updates is the posibility to measure lock bouncing.

-- 

