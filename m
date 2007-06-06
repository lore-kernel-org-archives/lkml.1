Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbXFFPFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbXFFPFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbXFFPFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:05:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbXFFPFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:05:33 -0400
Date: Wed, 6 Jun 2007 11:04:18 -0400
From: Dave Jones <davej@redhat.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add a trivial patch style checker v2
Message-ID: <20070606150418.GB3089@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Joel Schopp <jschopp@austin.ibm.com>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <735b25fd823d649f9cf55b63eb878b63@pinky> <Pine.LNX.4.62.0706061433430.10542@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0706061433430.10542@pademelon.sonytel.be>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 02:40:24PM +0200, Geert Uytterhoeven wrote:

 > Will http://www.codemonkey.org.uk/projects/checkpatch/checkpatch.git/ (hey, a
 > project with the same name started by the same person???) be merged in?

Andy and I were working on this in parallel with the same goal.
When his started to get traction, I stopped working on my variant.
Any regexps in my version that aren't in Andy's should of course be
merged.

	Dave

-- 
http://www.codemonkey.org.uk
