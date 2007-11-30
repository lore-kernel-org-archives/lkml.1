Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXK3WRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXK3WRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbXK3WQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:16:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:46134 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbXK3WQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:16:53 -0500
Message-Id: <BE453CED-64E1-46FD-8C13-D752F5B63A9D@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: mingo@redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: why is kmap_prot not always a define?
Date: Fri, 30 Nov 2007 16:16:26 -0600
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there some reason why kmap_prot isn't just a #define on all archs?

- k
