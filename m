Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbYA1VWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbYA1VWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYA1VWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:22:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:55662 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbYA1VWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:22:23 -0500
Date: Mon, 28 Jan 2008 13:20:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Jackson <pj@sgi.com>, michael-lists@free-electrons.com,
       rob@landley.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation: mention email-clients.txt in
 SubmittingPatches
Message-Id: <20080128132029.76e4d3ed.randy.dunlap@oracle.com>
In-Reply-To: <479E4201.8040500@oracle.com>
References: <200801181120.03168.michael-lists@free-electrons.com>
	<20080118083415.07c37f2a.randy.dunlap@oracle.com>
	<20080128095245.f8306466.pj@sgi.com>
	<20080128081759.4efa8544.randy.dunlap@oracle.com>
	<20080128133254.f70d50c2.pj@sgi.com>
	<479E4201.8040500@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

cc: Paul Jackson <pj@sgi.com>

This comment is not helpful (no reason given) and is incorrect.
Just stick to facts that are useful regarding working on Linux.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/email-clients.txt |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.24-git4.orig/Documentation/email-clients.txt
+++ linux-2.6.24-git4/Documentation/email-clients.txt
@@ -170,7 +170,6 @@ Sylpheed (GUI)
 
 - Works well for inlining text (or using attachments).
 - Allows use of an external editor.
-- Not good for IMAP.
 - Is slow on large folders.
 - Won't do TLS SMTP auth over a non-SSL connection.
 - Has a helpful ruler bar in the compose window.
