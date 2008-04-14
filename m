Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbYDNTm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbYDNTm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYDNTmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:42:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbYDNTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:42:20 -0400
Date: Mon, 14 Apr 2008 12:36:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, serue@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Message-Id: <20080414123624.0635798d.akpm@linux-foundation.org>
In-Reply-To: <6599ad830804140904v66fab79at8c12e19db64f6608@mail.gmail.com>
References: <48036677.3010807@linux.vnet.ibm.com>
	<48036F14.3050409@cs.helsinki.fi>
	<6599ad830804140904v66fab79at8c12e19db64f6608@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 09:04:28 -0700
"Paul Menage" <menage@google.com> wrote:

> On Mon, Apr 14, 2008 at 7:49 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Balbir Singh wrote:
> >
> > > If nobody has any specific objection to this patch, can I go ahead and
> > request
> > > Andrew to include this patch?
> > >
> >
> >  ->owner in struct mm_struct is very useful for revokeat() so
> >
> >  Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> 
> Reviewed-by: Paul Menage <menage@google.com>
> 
> I'm still not sure when to use Acked-by versus Reviewed-by - is it
> just based on the level of scrutiny/review?
> 

Yes.  Reviewed-by: is a lot stronger that Acked-by:.  I've seen some pretty
shocking Acked-by:'s :)

Documentation/SubmittingPatches goes into a surprising amount of detail.
