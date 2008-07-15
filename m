Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYGOMsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYGOMsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbYGOMry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:47:54 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2982 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758384AbYGOMrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:47:53 -0400
Date: Tue, 15 Jul 2008 15:47:34 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: s2disk: system powers up again after power off
Message-ID: <20080715124733.GA4111@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I use s2disk to suspend my HP 2510p notebook, it writes
everything to disk, and powers off... but after 2-3 seconds it often
powers on again.  This doesn't happen all the time but quite
frequently (definitely in the majority of cases).

I believe I've never seen this when I use "halt" to power off the
machine (but I don't use halt very often).

Any idea?
-- 
Martin Michlmayr
http://www.cyrius.com/
