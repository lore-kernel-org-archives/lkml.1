Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZCGVKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZCGVKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 16:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbZCGVK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 16:10:27 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:37596 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbZCGVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 16:10:26 -0500
Date: Sat, 7 Mar 2009 22:10:15 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: Expose a constant for the number of words
 representing the CRs
Message-ID: <20090307221015.7aff8204@de.ibm.com>
In-Reply-To: <87zlfzu0vw.fsf@caffeine.danplanet.com>
References: <1236271688-18806-1-git-send-email-danms@us.ibm.com>
	<87tz67vrkc.fsf@caffeine.danplanet.com>
	<20090305203527.48d7c2cd@skybook>
	<878wnjviwo.fsf@caffeine.danplanet.com>
	<20090305220926.58a380bf@skybook>
	<87zlfzu0vw.fsf@caffeine.danplanet.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Mar 2009 13:15:47 -0800
Dan Smith <danms@us.ibm.com> wrote:

> MS> The feature branch which contains the patches for the next merge
> MS> window contains your patch. I've added it a few weeks ago, but I
> MS> might have forgotten to drop you a note that I did so.
> 
> Ah, yeah, I never heard anything :)
> 
> The patch I sent earlier to day has been updated to catch another use
> of the magic '3'.  Can we replace the old with the new in that branch?

Sure, I've added the new one to my patch set.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

