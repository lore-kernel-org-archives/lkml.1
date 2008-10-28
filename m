Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJ1BEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJ1BEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYJ1BEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:04:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45575 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbYJ1BEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:04:10 -0400
X-Sasl-enc: 1H5Ws/hQUkPZTeoJ5wsA7gcWiPnXlE2pJ1Tthrms7LvN 1225155848
Subject: Re: [PATCH 2/6] autofs4 - remove string terminator check
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       autofs@linux.kernel.org
In-Reply-To: <20081027175541.3567e585.akpm@linux-foundation.org>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
	 <20081023023522.4508.27987.stgit@raven.themaw.net>
	 <20081027133131.f2011d28.akpm@linux-foundation.org>
	 <1225153622.2938.1.camel@zeus.themaw.net>
	 <20081027175541.3567e585.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 10:04:02 +0900
Message-Id: <1225155842.2938.19.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 17:55 -0700, Andrew Morton wrote:
> On Tue, 28 Oct 2008 09:27:02 +0900
> Ian Kent <raven@themaw.net> wrote:
> 
> > On Mon, 2008-10-27 at 13:31 -0700, Andrew Morton wrote:
> > > On Thu, 23 Oct 2008 10:35:22 +0800
> > > Ian Kent <raven@themaw.net> wrote:
> > > 
> > > > Remove unnecessary string terminator check.
> > > 
> > > Why is it unnecessary?
> > > 
> > > Does this change alter behaviour in any way?
> > > 
> > > Does it fix a bug?
> > 
> > Umm .... it was done in response to your comment, quoted below ...
> 
> umm, the number of patches I've handled recently overflowed a u16. 
> Please don't rely on my memory!  Plus "read akpm's mind" isn't a very
> useful changelog.
> 
> Please send a new and complete changelog for this patch?

OK, a resend will be done.

Ian


