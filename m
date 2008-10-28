Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYJ1A4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYJ1A4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYJ1A4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:56:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbYJ1A4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:56:42 -0400
Date: Mon, 27 Oct 2008 17:55:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       autofs@linux.kernel.org
Subject: Re: [PATCH 2/6] autofs4 - remove string terminator check
Message-Id: <20081027175541.3567e585.akpm@linux-foundation.org>
In-Reply-To: <1225153622.2938.1.camel@zeus.themaw.net>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
	<20081023023522.4508.27987.stgit@raven.themaw.net>
	<20081027133131.f2011d28.akpm@linux-foundation.org>
	<1225153622.2938.1.camel@zeus.themaw.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 09:27:02 +0900
Ian Kent <raven@themaw.net> wrote:

> On Mon, 2008-10-27 at 13:31 -0700, Andrew Morton wrote:
> > On Thu, 23 Oct 2008 10:35:22 +0800
> > Ian Kent <raven@themaw.net> wrote:
> > 
> > > Remove unnecessary string terminator check.
> > 
> > Why is it unnecessary?
> > 
> > Does this change alter behaviour in any way?
> > 
> > Does it fix a bug?
> 
> Umm .... it was done in response to your comment, quoted below ...

umm, the number of patches I've handled recently overflowed a u16. 
Please don't rely on my memory!  Plus "read akpm's mind" isn't a very
useful changelog.

Please send a new and complete changelog for this patch?
