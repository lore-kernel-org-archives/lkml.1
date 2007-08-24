Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbXHXMQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbXHXMQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXHXMP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:15:58 -0400
Received: from main.gmane.org ([80.91.229.2]:36590 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbXHXMP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:15:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: CFS + Rhythmbox audio skipping
Date: Fri, 24 Aug 2007 12:15:33 +0000 (UTC)
Message-ID: <pan.2007.08.24.12.15.32@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: d54c1e7e8.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago, it was already discussed here that Rhythmbox would easily 
cause audio skipping when running with the CFS scheduler (http://
bhhdoa.org.au/pipermail/ck/2007-June/007886.html). It was said to be a 
Rhythmbox problem, for which someone needed to open a bug report. Well, I 
just did this, but the developer says he cannot reproduce this, and denies 
that Rhythmbox is making any X calls in its audio playback thread, so this 
bug is blocked for the moment.

http://bugzilla.gnome.org/show_bug.cgi?id=467437

It seems that there are people who know better what is wrong exactly. Can 
somebody give some more details about what Rhythmbox is doing wrong, 
either here, either in the bug ticket?

-- 
Frederik Himpe


