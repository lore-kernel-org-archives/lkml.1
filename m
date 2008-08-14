Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbYHNJcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbYHNJcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYHNJcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:32:23 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:36588 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYHNJcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:32:22 -0400
Date: Thu, 14 Aug 2008 11:32:13 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc1 oops when plugging USB disk
Message-ID: <20080814093213.GA4674@ics.muni.cz>
References: <20080801133509.GD19548@ics.muni.cz> <20080814020416.20b18659.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080814020416.20b18659.akpm@linux-foundation.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 14 Aug 2008 11:32:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 02:04:16AM -0700, Andrew Morton wrote:
> Is this still happening in 2.6.27-rc3?

I'm unable to reproduce this any more with the current git head.

-- 
Luká¹ Hejtmánek
