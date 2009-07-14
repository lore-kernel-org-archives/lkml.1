Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZGNWlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZGNWlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZGNWlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:41:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469AbZGNWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:41:11 -0400
Date: Tue, 14 Jul 2009 15:40:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       sam@ravnborg.org, pavel@ucw.cz, randy.dunlap@oracle.com
Subject: Re: [PATCH] MAINTAINERS: Coalesce name and email address lines
Message-Id: <20090714154021.a8b0dfb7.akpm@linux-foundation.org>
In-Reply-To: <1247522300.4008.37.camel@Joe-Laptop.home>
References: <cover.1247517373.git.joe@perches.com>
	<1247522300.4008.37.camel@Joe-Laptop.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 14:58:19 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2009-07-13 at 14:14 -0700, Joe Perches wrote:
> > A collection of cleanup patches to MAINTAINERS
> 
> I ran the script I submitted awhile back on MAINTAINERS
> after these [0/16] patches are applied.
> 
> http://lkml.org/lkml/2009/6/1/275
> 
> I think the result is useful for people that rely
> on copy and paste of email addresses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
>  MAINTAINERS | 2722 ++++++++++++++++++++---------------------------------------
>  1 files changed, 908 insertions(+), 1814 deletions(-)

I don't think I want to have to maintain this patch for more than eight
minutes.  

Please send me a copy of that script so I can regenerate the patch when
it breaks.  I'll include it in the changelog of the patch, because
there's a decent chance that the patch will get broken during just the
several-hour lag between me pulling Linus's tree and sending patches at
him.

I could maintain these 17-odd patches until 2.6.32 opens, but there's
nothing to be gained by that so I think I'll hose them all Linuswards
later this week.
