Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbXGXFSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbXGXFSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbXGXFSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:18:33 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:27133 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXGXFSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:18:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRAGQopUZKhRO4Rmdsb2JhbACHNIgdAQEBIwYMAQ
Message-Id: <20070724044520.913891976.dtor@insightbb.com>
Date: Tue, 24 Jul 2007 00:45:20 -0400
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-input@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/RFT 0/5] Input locking patches
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I finally managed to put together some patches implementing
locking in input core and main input handles. Please look
over them and give them a spin.

--
Dmitry
