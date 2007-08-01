Return-Path: <linux-kernel-owner+w=401wt.eu-S1764783AbXHARun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764783AbXHARun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbXHARuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:50:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953AbXHARuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:50:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] BLOCK: Hide the contents of linux/bio.h if CONFIG_BLOCK=n
To: torvalds@osdl.org, akpm@osdl.org, James.Bottomley@SteelEye.com,
       jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 01 Aug 2007 18:49:46 +0100
Message-ID: <20070801174946.15877.86748.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Hide the contents of linux/bio.h if CONFIG_BLOCK=n as there shouldn't be
compiled that uses it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 0 files changed, 0 insertions(+), 0 deletions(-)


