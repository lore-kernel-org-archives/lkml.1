Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbYBGSOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbYBGSOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYBGSOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:14:38 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:46064 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbYBGSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:14:38 -0500
Message-ID: <47AB4A78.70609@qualcomm.com>
Date: Thu, 07 Feb 2008 10:14:16 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] CPU isolation extensions
References: <47AA9807.7090402@qualcomm.com>	<20080206215805.17a0c919.akpm@linux-foundation.org>	<20080207015954.92cd3878.pj@sgi.com> <20080207001235.a9baac90.akpm@linux-foundation.org>
In-Reply-To: <20080207001235.a9baac90.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 7 Feb 2008 01:59:54 -0600 Paul Jackson <pj@sgi.com> wrote:
> 
>> but hard real time is not my expertise
> 
> Speaking of which..  there is the -rt tree.  Have those people had a look
> at the feature, perhaps played with the code?

Peter Z. and Steven R. sent me some comments, I believe I explained and addressed them.
Ingo's been quite. Probably too busy.

btw It's not an RT feature per se. It certainly helps RT but removing all the latency
sources from isolated CPUs. But in general it's just "reducing kernel overhead on some CPUs"
kind of feature.

Max 
