Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbYEETC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbYEETC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759701AbYEETCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:02:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33400 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752711AbYEETCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:02:42 -0400
Message-Id: <20080505190213.714827651@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 12:02:13 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 0/4] [PATCH] x86: Merge e820_32/64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset merges the 32 and 64 bit of e820 header files into one.

First just move the stuff into a single file and then gradually extract common
code.

Patch against Linus git of today.

-- 
