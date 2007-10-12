Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbXJLQcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbXJLQcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760602AbXJLQJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760521AbXJLQJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 52/52] CRED: Pass credentials through vfs_mkdir()
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:45 +0100
Message-ID: <20071012160945.15119.55896.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through vfs_mkdir().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 0 files changed, 0 insertions(+), 0 deletions(-)


