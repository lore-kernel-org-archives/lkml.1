Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYLLNoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYLLNoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbYLLNoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:44:06 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36695 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040AbYLLNoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:44:05 -0500
Date: Fri, 12 Dec 2008 14:44:09 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>
Subject: Re: Bug in i915 GEM module
Message-ID: <20081212134409.GA4346@ics.muni.cz>
References: <20081208190235.GA4498@ics.muni.cz> <20081210102749.fa39877c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081210102749.fa39877c.akpm@linux-foundation.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 12 Dec 2008 14:43:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 10:27:49AM -0800, Andrew Morton wrote:
> Eric tells me "The main kernel bug here is already fixed in the code
> Linus just pulled.  There's a little bugfix for the error path to avoid
> triggering the BUG, which could happen after the main fix if we lost a
> race for a signal."
> 
> So please retest Linus's current git tree, thanks.

it seems to be OK with the latest git.

-- 
Luká¹ Hejtmánek
