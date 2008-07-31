Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbYGaBa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbYGaBa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYGaBao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:30:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47581 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbYGaBan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:30:43 -0400
Message-Id: <20080731012208.115225969@vergenet.net>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 11:22:08 +1000
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
From: Simon Horman <horms@verge.net.au>
Subject: [patch 0/6] is_kdump_kernel() cleanup and related patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series contains all the patches (that I am aware of)
that have recently been posted regarding kdump and in particular
is_kdump_kernel()

For Andrew Morton's benefit I have annotated each patch as to whether it
needs to be included in 2.6.27 or not. My conclusion is that while
I would like to see all of the patches included in 2.6.27, none
of them are particularly dire, and thus they could all wait until
post-2.6.27.

-- 
Horms

