Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbZGSWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbZGSWWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZGSWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:22:37 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53671 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751537AbZGSWWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:22:37 -0400
Date: Sun, 19 Jul 2009 17:22:36 -0500
From: Robin Holt <holt@sgi.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Commit 9b57896e removed my Vaio S1 S2 keys for brightness +/-.
Message-ID: <20090719222236.GJ6876@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

I am not sure whether this is a bug or just something not configured
correctly.  I am running Ubuntu 9.04 and finally decided to find out why
the S1 and S2 buttons no longer brighten or dim the display.  Prior to
commit 9b57896e, they behaved equivalent to the Fn-F5 and Fn-F6 keys
for brightness up/down.

I am willing to help isolate this further.  What can I provide?

Thanks,
Robin
