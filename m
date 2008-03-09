Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYCIQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYCIQoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYCIQoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 12:44:44 -0400
Received: from sandeen.net ([209.173.210.139]:29404 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbYCIQoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 12:44:44 -0400
Message-ID: <47D413FA.50602@sandeen.net>
Date: Sun, 09 Mar 2008 11:44:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: 2.6.25-rc hangs
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de> <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> On Sat, 8 Mar 2008, Christian Kujau wrote:
>> FWIW, it's 100% reproducible with 2.6.25-rc3 too...sigh :-\
>> So, the last working kernel for me is 2.6.24.1 - that's a lot of bisecting 
>> and I fear that compile errors will invalidate the bisecting results again or 
>> make it impossible at all....I'll try anyway....tomorrow...
> 
> Bisecting failed as expected :-(
> I tried to follow the git-bisect manpage (and have successfully used 
> bisect in the past a few times), but I think ~5700 revisions between 
> 2.6.24 and 2.6.25 are just too much fuzz. The bisect logs so far, with
> my comments inbetween:

Christian, what is the test you are using for the bisect?

Thanks,
-Eric
