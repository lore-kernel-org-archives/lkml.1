Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXDSHA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXDSHA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXDSHA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:00:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46340 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161469AbXDSHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:00:48 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] synchro_test: Convert to the kthread API.
Date: Thu, 19 Apr 2007 00:56:02 -0600
Message-Id: <11769658221939-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


