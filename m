Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYAWIsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYAWIsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYAWIs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:48:26 -0500
Received: from ns2.suse.de ([195.135.220.15]:59453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYAWIsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:48:25 -0500
To: Karl Kiniger <karl.kiniger@med.ge.com>
Cc: David Newall <davidn@davidnewall.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org>
	<4792B191.2060801@davidnewall.com>
	<20080120031153.GB6275@one.firstfloor.org>
	<4792D221.1010704@davidnewall.com>
	<20080120051822.GB19784@one.firstfloor.org>
	<4792DD22.4070902@davidnewall.com>
	<20080120055544.GB19861@one.firstfloor.org>
	<4792E8E2.1090307@davidnewall.com>
	<20080120072922.GA21047@one.firstfloor.org>
	<4793F775.6090403@davidnewall.com>
	<20080122102436.GA15563@wszip-kinigka.euro.med.ge.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jan 2008 09:48:20 +0100
In-Reply-To: <20080122102436.GA15563@wszip-kinigka.euro.med.ge.com>
Message-ID: <p73k5m1lygb.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Kiniger <karl.kiniger@med.ge.com> writes:

> FYI, 
> 
> on http://www.feise.com/~jfeise/Downloads/linux-abi/
> 
> a patch named  linux-abi-2.6.22.3_3.diff.bz2 can be found.

So just add a reversed version of my binfmt_elf patch to that.
If people need to apply a patch anyways it doesn't make much
difference if it has a few more hunks.

-Andi
