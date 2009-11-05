Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZKER4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZKER4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbZKER4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:56:52 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55736 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbZKER4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:56:49 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADOh8kqrR7H+/2dsb2JhbADJAJdzhD0E
X-IronPort-AV: E=Sophos;i="4.44,687,1249257600"; 
   d="scan'208";a="102612714"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Michael Gilbert <michael.s.gilbert@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com>
	<alpine.LRH.2.00.0911051620510.31913@twin.jikos.cz>
	<alpine.LFD.2.01.0911050831330.31845@localhost.localdomain>
	<alpine.LFD.2.01.0911050923580.31845@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Nov 2009 09:56:53 -0800
In-Reply-To: <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain>
	(Linus Torvalds's message of "Thu, 5 Nov 2009 09:38:21 -0800 (PST)")
Message-ID: <aday6mkc0t6.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Nov 2009 17:56:54.0210 (UTC) FILETIME=[5BF44220:01CA5E41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > So here's a second try. I guess the 'return count/-EFAULT' lines were
 > actually correct after all. So it wasn't _all_ buggy or insane.

The blank lines seem fine too.

 - R.
