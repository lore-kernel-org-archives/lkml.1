Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbYIXJFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbYIXJFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYIXJFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:05:15 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:61457 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYIXJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:05:14 -0400
Message-Id: <20080924090317.359685535@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Wed, 24 Sep 2008 18:03:17 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, haradats@nttdata.co.jp
Subject: [TOMOYO #9 (2.6.27-rc7-mm1) 0/6] TOMOYO Linux
X-OriginalArrivalTime: 24 Sep 2008 09:05:11.0221 (UTC) FILETIME=[A62A3650:01C91E24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is a pathname-based MAC extension (LSM module) for the
Linux kernel. The current mmotm (2008-09-23-11-27) includes LSM hooks
for pathname-based security. This posting uses these hooks.

Please review the body of TOMOYO Linux.

To use TOMOYO Linux, some userspace tools are needed. These tools and
documents are available at http://tomoyo.sourceforge.jp/ .

Regards,
--

