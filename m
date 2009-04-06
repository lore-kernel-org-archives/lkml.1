Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbZDFWCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbZDFWCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760631AbZDFV4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:56:19 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50876 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760622AbZDFV4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:56:19 -0400
Date: Mon, 6 Apr 2009 17:56:17 -0400
To: Mark Lord <lkml@rtr.ca>
Cc: Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: Linux 2.6.29
Message-ID: <20090406215617.GE3797@csclub.uwaterloo.ca>
References: <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <x49myaxjrsb.fsf@segfault.boston.devel.redhat.com> <20090406141516.GM3795@csclub.uwaterloo.ca> <49DA73AE.5020106@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DA73AE.5020106@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 05:27:10PM -0400, Mark Lord wrote:
> Yeah, I think the sync_file_range() patch is the way to go.
> It seems to be smooth enough here with four or five simultaneous recordings,
> a couple of commflaggers, and an HD playback all happening at once.

Well would be worth a try.  So far I am not sure if the slice_idle works
or not.  I will have to try playback when I get home and see how it feels.

-- 
Len Sorensen
