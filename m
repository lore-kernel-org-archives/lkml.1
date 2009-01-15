Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbZAORuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbZAORuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbZAORuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:50:00 -0500
Received: from relay3.sgi.com ([192.48.171.31]:46681 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757980AbZAORuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:50:00 -0500
Message-Id: <20090115174948.731212661@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 15 Jan 2009 11:49:48 -0600
From: holt@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dcn@sgi.com
Subject: [patch 0/3] sgi-xpc: Fixups for two bugs and some cleanup [Resend].
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches fix two difficult to detect bugs in
SGI's XPC.
