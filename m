Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbXEKQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbXEKQ7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758804AbXEKQ7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:59:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757075AbXEKQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:59:46 -0400
Message-Id: <20070511165749.026947116@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 May 2007 09:57:49 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/2] Remove destructor support from slab allocators
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the last use of a slab destructor in the sh arch
and then removes destructor support.

-- 
