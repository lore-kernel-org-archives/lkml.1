Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYIYQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYIYQaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYIYQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:30:13 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:35823 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYIYQaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:30:12 -0400
Date: Thu, 25 Sep 2008 18:30:24 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27-rc7 no init found on the root partition?
Message-ID: <20080925163024.GP31582@ics.muni.cz>
References: <20080924192227.GC31582@ics.muni.cz> <20080924230326.GM5448@disturbed> <20080925111239.GF31582@ics.muni.cz> <48DB96B8.6050503@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48DB96B8.6050503@sandeen.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 25 Sep 2008 18:30:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 08:48:40AM -0500, Eric Sandeen wrote:
> Is it possible that device ordering has changed?  what if you do:

no, using printk's I found that search_binary_handler is the one that fails.
Dunno why.

-- 
Luká¹ Hejtmánek
