Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbZJUFBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbZJUFBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 01:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZJUFBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 01:01:08 -0400
Received: from thunk.org ([69.25.196.29]:57929 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZJUFBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 01:01:07 -0400
Date: Wed, 21 Oct 2009 00:48:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091021044834.GA18788@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <20091012120510.16bd1194@jbarnes-g45> <20091013023146.GA8414@mit.edu> <20091013100135.2b3d914f@jbarnes-g45> <20091013190055.GI8175@mit.edu> <20091013121426.35f409ff@jbarnes-g45> <20091014142252.009d03a5@jbarnes-g45> <20091015022645.GA8286@mit.edu> <20091015040204.GE8286@mit.edu> <20091019100437.22b6ea36@jbarnes-x200> <20091019101526.5496d5ed@jbarnes-x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019101526.5496d5ed@jbarnes-x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 10:15:26AM +0900, Jesse Barnes wrote:
> > 
> > Ok, hopefully this is the "correct" patch.  It works for me, can you
> > give it a try?
> 
> Here's an even more "final" patchset with some spurious hunks removed.

This seems to work for me, thanks!!!

					- Ted
