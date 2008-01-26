Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYAZAek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYAZAek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYAZAe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:34:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbYAZAe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:34:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Q: x86 suspend/hibernation code consolidation
Date: Sat, 26 Jan 2008 01:32:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801260132.09529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to move the 64-bit suspend/hibernation files from arch/x86/kernel to
arch/x86/power, modify the names of the 32-bit files already in
arch/x86/power and update the Makefiles accordingly, but there are some changes
queued for merging that touch the files in question.

When is the right time for making changes like that?

Rafael
