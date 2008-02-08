Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbYBHIMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbYBHIMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbYBHIM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:12:28 -0500
Received: from mail.suse.de ([195.135.220.2]:39304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbYBHIM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:12:28 -0500
Date: Fri, 8 Feb 2008 09:12:26 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com
Subject: Re: IO queuing and complete affinity with threads (was Re: [PATCH 0/8] IO queuing and complete affinity)
Message-ID: <20080208081226.GH9730@wotan.suse.de>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <20080207182544.GM15220@kernel.dk> <20080208073859.GE9730@wotan.suse.de> <20080208074747.GY15220@kernel.dk> <20080208075324.GG9730@wotan.suse.de> <20080208075954.GA15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208075954.GA15220@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 08:59:55AM +0100, Jens Axboe wrote:
> On Fri, Feb 08 2008, Nick Piggin wrote:
> > And if you don't?
> 
> Well if you don't ask for anything, you wont get anything :-)
> As I mentioned, the patch is a playing ground for trying various setups.
> Everything defaults to 'do as usual', set options to setup certain test
> scenarios.

I mean if you don't know the completing CPU.

