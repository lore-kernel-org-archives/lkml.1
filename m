Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZCEVJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZCEVJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZCEVJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:09:34 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:58562 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZCEVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:09:33 -0500
Date: Thu, 5 Mar 2009 22:09:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: Expose a constant for the number of words
 representing the CRs
Message-ID: <20090305220926.58a380bf@skybook>
In-Reply-To: <878wnjviwo.fsf@caffeine.danplanet.com>
References: <1236271688-18806-1-git-send-email-danms@us.ibm.com>
	<87tz67vrkc.fsf@caffeine.danplanet.com>
	<20090305203527.48d7c2cd@skybook>
	<878wnjviwo.fsf@caffeine.danplanet.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Mar 2009 12:01:11 -0800
Dan Smith <danms@us.ibm.com> wrote:

> MS> Have you looked at git390 lately ?
> 
> Yes.  My patch still applies cleanly there.  What am I missing?

You need to look at the correct branch:

http://git390.marist.edu/cgi-bin/gitweb.cgi?p=linux-2.6.git;a=shortlog;h=refs/heads/features

The feature branch which contains the patches for the next merge window
contains your patch. I've added it a few weeks ago, but I might have
forgotten to drop you a note that I did so.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

