Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbYCMFE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbYCMFE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 01:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYCMFET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 01:04:19 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40697 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbYCMFET (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 01:04:19 -0400
Date: Thu, 13 Mar 2008 16:03:35 +1100
From: David Chinner <dgc@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Message-ID: <20080313050335.GX155259@sgi.com>
References: <200803110014.52985.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803110014.52985.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 12:14:52AM +0100, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2008-03-07 21:32
> References	: http://lkml.org/lkml/2008/3/7/308
> 		  http://lkml.org/lkml/2008/3/9/186
> Handled-By	: David Chinner <dgc@sgi.com>

Rafael, this looks to be something related to dm-crypt, not XFS. Can you
reassign it appropriately?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
