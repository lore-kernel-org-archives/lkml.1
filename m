Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbYDNQfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbYDNQfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYDNQfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:35:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2148 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYDNQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:35:46 -0400
Subject: 2.6.25-rc9-dw1
From: Daniel Walker <dwalker@mvista.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:35:44 -0700
Message-Id: <1208190944.4877.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a pure Real Time forward port. I started with my bisect changes
to 2.6.24.4-rt4. This version should be more bisectable than the
original release.

Some of the few things that are missing are all of ftrace, and most of
the additional preemptible RCU changes (most of which got merged for
2.6.25 or just aren't needed).

It's only available in broken out form. You can download it from,

ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.25-rc9-dw1-broken-out.tar.bz2

Check for updates here,

ftp://source.mvista.com/pub/dwalker/rt/

Enjoy!

Daniel

