Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbYGIMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbYGIMwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYGIMwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:52:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYGIMwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:52:02 -0400
Message-Id: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 00/11] remove CONFIG_KMOD
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've rebased this patch series against -next-20080708 (one conflict
against ftrace, another against BKL pushdown) and fixed the things
Adrian Bunk pointed out.

johannes
