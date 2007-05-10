Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbXEJKTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbXEJKTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761122AbXEJKQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:16:09 -0400
Received: from mailhub.hp.com ([192.151.27.10]:49622 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760969AbXEJKQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:16:07 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Thu, 10 May 2007 06:16:05 -0400
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, robert.picco@hp.com
Subject: Re: hpet on hp proliant dl380 g5 4 cores
Message-ID: <20070510101605.GK10881@localhost>
References: <5d96567b0705091102j7168620fu8476e7756a8d8b5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0705091102j7168620fu8476e7756a8d8b5f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:
Raz Ben-Jehuda(caro) wrote:	[Wed May 09 2007, 02:02:24PM EDT]
> Hello Robert.
> I have noticed that you are the writer of the hpet driver in linux.
> I have been running the test tool provided in
> linux/Documenration/hpet.txt  on an hp dl380. It runs for few seconds
> and then the hpet timer clock stopped interrupting ( I looked at
> /proc/interrupts). It happens faster when i increased the frequency
> (starting from 1000 to 16000) . But is always happens.
> 
> Do you why ?
I don't have a clue. All my dl's don't have hpet bios enabled.

bob
> 
> Thank you
> -- 
> Raz
