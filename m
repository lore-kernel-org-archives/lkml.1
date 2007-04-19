Return-Path: <linux-kernel-owner+w=401wt.eu-S1161276AbXDSIRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276AbXDSIRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993183AbXDSIE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:04:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45787 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993176AbXDSID6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:03:58 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] synchro_test: Convert to the kthread API.
Date: Thu, 19 Apr 2007 01:59:07 -0600
Message-Id: <1176969643793-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


