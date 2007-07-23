Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbXGWUJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbXGWUJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934319AbXGWUJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:09:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:56719 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955AbXGWUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:09:16 -0400
Date: Mon, 23 Jul 2007 16:08:58 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [ANNOUNCE] seekwatcher IO graphing v0.2
Message-ID: <20070723160858.0d1715d2@think.oraclecorp.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello everyone,

Since doing the initial Btrfs benchmarks, I've made my blktrace graphing
utility a little more generic and tossed it out on oss.oracle.com.

This new version can easily graph two different runs, and has a few
other tweaks that make the graphs look nicer.

Docs, examples and other details are at:

http://oss.oracle.com/~mason/seekwatcher

-chris
