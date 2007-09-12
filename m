Return-Path: <linux-kernel-owner+w=401wt.eu-S934881AbXILQYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbXILQYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934128AbXILQYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:24:05 -0400
Received: from main.gmane.org ([80.91.229.2]:41812 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934199AbXILQYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:24:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dan Stromberg <dstromberglists@gmail.com>
Subject: Building a kernel-source RPM (not a kernel RPM)?
Date: Wed, 12 Sep 2007 09:13:41 -0700
Message-ID: <pan.2007.09.12.16.13.41.195991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: wsip-64-58-157-227.oc.oc.cox.net
User-Agent: Pan/0.14.2 (This is not a psychotic episode. It's a cleansing moment of clarity.)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I sent this to kernel newbies first, and while I got one response there,
it answered a different question than the one I was asking...

I'm on a SuSE system.

I'm working on automating the install of said system, but it needs a
Linus kernel - 2.6.21.7 specifically, and it needs kernel source too so
that we can build modules in the field as needed.

I see you can make an rpm of a bootable kernel with "make rpm".

Is there a streamlined way of building a corresponding kernel-source
RPM?  Or do people pretty much all just dump the source in /usr/src, and
manually update symlinks as needed?  If the latter, what symlinks need
to be updated?


