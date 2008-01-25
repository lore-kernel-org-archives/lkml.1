Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYAYBUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYAYBUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYAYBUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:20:33 -0500
Received: from mail.cyberdogtech.com ([64.22.125.39]:56917 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYAYBU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:20:28 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 20:20:28 EST
Date: Thu, 24 Jan 2008 19:12:01 -0600
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Subject: "Default Linux Capabilities" default in 2.6.24
Message-Id: <20080124191201.324cf1a0.kernel1@cyberdogtech.com>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm doing a make oldconfig with the new 2.6.24 kernel.  I came to the prompt for "Default Linux Capabilities" which defaults to No:

---
 Default Linux Capabilities (SECURITY_CAPABILITIES) [N/y/?] (NEW) ?
---

However the help text recommends saying Yes.

---
 This enables the "default" Linux capabilities functionality.
 If you are unsure how to answer this question, answer Y.
---

Does this seem incongruous?  Also, what's the "question"? :)

Thanks, 
Matt LaPlante
