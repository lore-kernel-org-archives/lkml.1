Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbYD2LM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbYD2LM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYD2LMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:12:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46477 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYD2LMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:12:18 -0400
Subject: [PATCH 0/12] Further PDE->data assignments cleanups
From: "Denis V. Lunev" <den@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Parallels
Date: Tue, 29 Apr 2008 15:12:18 +0400
Message-Id: <1209467538.29647.11.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches replaces proc_create/etc and further PDE->data
assignment mostly with proc_data_create.

Signed-off-by: Denis V. Lunev <den@openvz.org>

