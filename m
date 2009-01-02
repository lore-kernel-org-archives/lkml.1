Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZABJUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZABJUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbZABJUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:20:22 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:43787 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZABJUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:20:21 -0500
Subject: Re: [PATCH] asm-s390/posix_types.h: drop __USE_ALL usage
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
In-Reply-To: <200901020355.37186.vapier@gentoo.org>
References: <1230882782-9977-1-git-send-email-vapier@gentoo.org>
	 <1230886227.5474.0.camel@localhost>  <200901020355.37186.vapier@gentoo.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 02 Jan 2009 10:20:17 +0100
Message-Id: <1230888017.5474.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 03:55 -0500, Mike Frysinger wrote:
> On Friday 02 January 2009 03:50:27 Martin Schwidefsky wrote:
> > On Fri, 2009-01-02 at 02:53 -0500, Mike Frysinger wrote:
> > > Bring s390 in line with all the other ports.  Not sure how s390 missed
> > > this change as all the other arches were being updated ...
> >
> > Should I carry the patch via git390?
> 
> i dont know what "git390" is, but it makes no difference to me how it gets 
> merged.  whatever is easiest for people.

git390 == git://git390.osdl.marist.edu/pub/scm/linux-2.6.git

I'll add the patch to the queue for the next s390 update.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


