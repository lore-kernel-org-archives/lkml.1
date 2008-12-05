Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYLEQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYLEQWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYLEQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:21:51 -0500
Received: from ping.pong.ch ([212.103.71.101]:51504 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYLEQVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:21:51 -0500
Date: Fri, 5 Dec 2008 17:21:43 +0100
From: Gaudenz Steinlin <gaudenz@debian.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #12158] commit b1ee26b freezes system on switching from X
	to text console
Message-ID: <20081205162143.GA6085@soziologie.ch>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.8DH.voxNJB@chimera> <alpine.LFD.2.00.0812031642280.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812031642280.3256@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 04:44:03PM -0800, Linus Torvalds wrote:
 
> I think we're assuming that this already got fixed by commit 
> c4c6fa9891f3d1bcaae4f39fb751d5302965b566 ("radeonfb: fix problem with 
> color expansion & alignment").
> 
> Gaudenz?

Sorry, no, this commit does not fix my bug. 

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
