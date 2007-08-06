Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXHFSqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXHFSqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbXHFSqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:46:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:40823 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758530AbXHFSqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:46:37 -0400
In-Reply-To: <200708020440.l724edCT290676@shell01.TheWorld.com>
References: <200708020440.l724edCT290676@shell01.TheWorld.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <a650790070fdbccce792ea78776cf8a5@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: matt@genesi-usa.com (Matt Sealey), linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
Date: Mon, 6 Aug 2007 20:45:52 +0200
To: Alan Curry <pacman@TheWorld.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> You don't need to patch Linux at all. In fact for silly things like 
>> this
>> I would recommend against it :)
>
> If the workaround doesn't go into the kernel, everybody with affected
> hardware has to individually find out about the bug (probably by 
> experiencing
> an annoying keyboardless boot) and fix it himself.

That's one of the reasons why this should go into a bootwrapper.


Segher

