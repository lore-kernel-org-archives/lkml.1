Return-Path: <linux-kernel-owner+w=401wt.eu-S1751425AbZJOEdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbZJOEdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 00:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZJOEdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 00:33:46 -0400
Received: from thunk.org ([69.25.196.29]:45317 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbZJOEdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 00:33:45 -0400
Date: Thu, 15 Oct 2009 00:02:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091015040204.GE8286@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <20091010204106.GA8251@mit.edu> <20091012095438.1e82b54f@jbarnes-g45> <20091012184651.GA4603@Pilar.aei.mpg.de> <20091012120510.16bd1194@jbarnes-g45> <20091013023146.GA8414@mit.edu> <20091013100135.2b3d914f@jbarnes-g45> <20091013190055.GI8175@mit.edu> <20091013121426.35f409ff@jbarnes-g45> <20091014142252.009d03a5@jbarnes-g45> <20091015022645.GA8286@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015022645.GA8286@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:26:45PM -0400, Theodore Tso wrote:
> 
> If I need to live with a display glitch every 5-10 minutes or so to
> get better power savings, I'll take it....
> 

While mail reading and composing responses in a tty based mail reader
(mutt/emacs -nw), I'm seeing display glitches every 3-5 minutes.  Each
time it's quite minor so it's the sort of thing which is definitely
"blink at the wrong time and you'll miss it".

Being a battery lifetime freak, I'll definitely take the tradeoff, but
given that it occurs even when I'm plugged into AC mains, I could see
some users being annoyed by it, and I could see them wanting to be
able to switch off the feature when they are on AC, if we find a
complete fix.

						- Ted



