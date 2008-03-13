Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYCMVNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYCMVNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYCMVNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:13:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbYCMVND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:13:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Date: Thu, 13 Mar 2008 22:12:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
References: <200803110014.52985.rjw@sisk.pl> <20080313050335.GX155259@sgi.com>
In-Reply-To: <20080313050335.GX155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132212.03799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of March 2008, David Chinner wrote:
> On Tue, Mar 11, 2008 at 12:14:52AM +0100, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> > Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > Date		: 2008-03-07 21:32
> > References	: http://lkml.org/lkml/2008/3/7/308
> > 		  http://lkml.org/lkml/2008/3/9/186
> > Handled-By	: David Chinner <dgc@sgi.com>
> 
> Rafael, this looks to be something related to dm-crypt, not XFS. Can you
> reassign it appropriately?

Well, it's already been assigned to IO/Storage->LVM2/DM, but I've reassigned
it to Herbert Xu.

Thanks,
Rafael
