Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXDZTCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXDZTCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbXDZTCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:02:37 -0400
Received: from 1wt.eu ([62.212.114.60]:2285 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbXDZTCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:02:36 -0400
Date: Thu, 26 Apr 2007 21:02:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426190218.GU943@1wt.eu>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <Pine.LNX.4.61.0704261005100.506@yvahk01.tjqt.qr> <alpine.LFD.0.98.0704260930010.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704260930010.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 09:40:26AM -0700, Linus Torvalds wrote:

> So we should have somebody like Christoph running -mm, and when things 
> break, we'll just sic Christoph on whoever broke it, and teach people 
> proper fear and respect!

And with Al Viro doing random code review and fill in the commits for
regression fixes, even long established developers will check their code
twice before submitting ;-)

Willy

