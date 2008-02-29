Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbYB2WsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbYB2WsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbYB2WsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:48:13 -0500
Received: from khc.piap.pl ([195.187.100.11]:52703 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760587AbYB2WsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:48:12 -0500
To: <linux-kernel@vger.kernel.org>
Subject: Few ideas...
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 29 Feb 2008 23:48:10 +0100
Message-ID: <m3od9z9y6t.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There was a thread about MODULE_MAINTAINER but how about a tag which
a) would be present in source files, not necessarily one per module
c) would be machine-parseable
d) would have _no_ effect on object code (i.e., would be ignored by
   the compiler completely)?

I guess it would be more useful than current MAINTAINERS file and we
would at last know immediately what to put in "To:" line.



Another idea? Why don't we move all the kernel-related lists to
vger.kernel.org, making them "open" in the process?



Want more? :-)
-- 
Krzysztof Halasa
