Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbXBVVZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbXBVVZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXBVVZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:25:47 -0500
Received: from twin.jikos.cz ([213.151.79.26]:35635 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbXBVVZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:25:45 -0500
Date: Thu, 22 Feb 2007 22:24:27 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: webmaster@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: gitweb on kernel.org buggy?
Message-ID: <Pine.LNX.4.64.0702222219520.10496@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the gitweb running on git(2).kernel.org has looked buggy to me for quite a 
some time (a month or so) with respect to branches vs. shortlog.

When you browse a repository with mutliple branches, and switch between 
branches, the shortlog shown is always the one from master, never from the 
branch you switched to, which seems wrong to me.

This definitely worked previously (and works on other installations of 
gitweb outside the kernel.org), so it might be worth fixing.

Thanks,

-- 
Jiri Kosina
