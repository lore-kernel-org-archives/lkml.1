Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZDKUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZDKUat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbZDKU3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:29:53 -0400
Received: from thunk.org ([69.25.196.29]:55358 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbZDKU3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:29:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: [PATCH, RFC 0/3] Improvements to the tracing documentation
Date: Sat, 11 Apr 2009 15:51:16 -0400
Message-Id: <1239479479-2603-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the kernel panel at the Linux Foundation Collaboration Summit, I
mentioned that the documentation for the tracing subsystem could be
improved; in particular, that very often the needed documentation for
how the various tracers worked could only be found in the git commit
logs, Kconfig files, and of course, reading the source.

Since criticisms should be followed up with some attempts to improve
the situation, here are some patches to improve the tracing
documentation.

I'm not sure the documentation is 100% correct, but by submitting it,
hopefully that the tracer authors will get flushed out of the woodwork
and be inspired to improve what has been submitted.  :-)

	     		    	    		 - Ted
