Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYJCTm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYJCTm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYJCTmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:42:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44275 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752757AbYJCTmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:42:19 -0400
Date: Wed, 1 Oct 2008 22:03:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message
	when running as VMware guest
Message-ID: <20081001200351.GA2121@ucw.cz>
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com> <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Subject says: Suppress false "mtrr all empty"  .... would you explain
why is the message false? I believe it is very true, and points out
fact that VMWare virtualization fails to simulate MTRR-s.

IMO VMWare should just fix their emulator.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
