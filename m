Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYKMXp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYKMXp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYKMXpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:45:34 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55244 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYKMXpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:45:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task directories
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
	<m1abccxpc5.fsf@frodo.ebiederm.org>
	<20081106184945.179c248a.akpm@linux-foundation.org>
	<m1iqr0urb8.fsf@frodo.ebiederm.org>
	<20081106202822.a1af8a6e.akpm@linux-foundation.org>
	<m1d4h7v8jf.fsf@frodo.ebiederm.org>
	<20081107080529.6f4de3ad.akpm@linux-foundation.org>
Date: Thu, 13 Nov 2008 15:39:44 -0800
In-Reply-To: <20081107080529.6f4de3ad.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 7 Nov 2008 08:05:29 -0800")
Message-ID: <m1zlk3kxfj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On this patchset it looks like the conversation has wound down with no
real objects except that some very simple pieces of the code appear
magic.


What looks to be the best path for getting this set of patches merged
into /proc?

Alexy will you pick this up in your /proc tree as Andrew suggested?
Do I need to keep my own tree?

Can I have some clear guidance on which hurdles to jump through to
make forward progress?

Eric

