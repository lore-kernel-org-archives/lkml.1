Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbYBVWhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbYBVWhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYBVWhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:37:15 -0500
Received: from khc.piap.pl ([195.187.100.11]:48769 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbYBVWhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:37:13 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Newall <davidn@davidnewall.com>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	<m3tzk1q3rt.fsf@maximus.localdomain>
	<47BE2985.6020305@davidnewall.com>
	<20080222020615.GE27894@ZenIV.linux.org.uk>
	<alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 22 Feb 2008 23:37:11 +0100
In-Reply-To: <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 21 Feb 2008 19\:13\:19 -0800 \(PST\)")
Message-ID: <m34pc04nzc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Will people then try to fake things out by using 4-space indents 
> and then "deep" indentations will look like just a couple of tabs?)

There is no point in faking it as it's only advisory, it's to help the
author who should be free to ignore the advice. People upstream won't
be fooled by some cheap tab tricks I guess.
-- 
Krzysztof Halasa
