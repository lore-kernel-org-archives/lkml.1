Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbYASB7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbYASB7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbYASB7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:59:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbYASB7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:59:14 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/6] lguest patches for compiling x86_64
Date: Fri, 18 Jan 2008 23:59:04 -0200
Message-Id: <1200707950911-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, I have lguest in-tree module compiling on x86_64.
It's not yet on a sendable state, since the module itself isn't loading.

However, this subset of the series is pretty straightforward, and I'm sending it
now aiming at reducing the delta size in the future ;-)

Have fun,


