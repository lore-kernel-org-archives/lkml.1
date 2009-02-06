Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZBFO1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZBFO1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZBFO1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:27:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1493 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZBFO1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:27:35 -0500
Date: Fri, 6 Feb 2009 14:27:25 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <20090206142725.GA9455@sirena.org.uk>
References: <1232997799-18943-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090202135650.838a3ddd.akpm@linux-foundation.org> <20090206135431.GA3341@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206135431.GA3341@sortiz.org>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: Support active high IRQs on WM835x
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 02:54:32PM +0100, Samuel Ortiz wrote:

> Sorry for the latency. Our mailserver had some issues, and I was quite busy
> fixing wireless drivers myself :/

No problem.

> I'm back on track now. Mark, I havent got those 2 mfd patches. Did you send
> them to me for merging ? If that's so, could you please resend them ?

I resent the patches that you hadn't merged yesterday when the commits
showed up in -next - I figured they must've slipped through the cracks
when you were catching up.  It was just those two.
