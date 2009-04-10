Return-Path: <linux-kernel-owner+w=401wt.eu-S938244AbZDJUtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938244AbZDJUtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764065AbZDJUs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:48:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762589AbZDJUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:48:57 -0400
Date: Fri, 10 Apr 2009 13:47:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] GRU - GRU Driver updates
Message-Id: <20090410134716.69c08ff9.akpm@linux-foundation.org>
In-Reply-To: <20090410123111.GA9897@sgi.com>
References: <20090406160809.278924000@sgi.com>
	<20090409153701.d8bf4c20.akpm@linux-foundation.org>
	<20090410123111.GA9897@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 07:31:11 -0500
Jack Steiner <steiner@sgi.com> wrote:

> On Thu, Apr 09, 2009 at 03:37:01PM -0700, Andrew Morton wrote:
> > On Mon, 06 Apr 2009 11:08:09 -0500
> > steiner@sgi.com wrote:
> > 
> > > 
> > > This patchset is a collection of patches to the GRU driver.
> > > All changes are internal to the driver and have no effect
> > > on the core kernel or interfaces to/from the core kernel.
> > 
> > Do you believe that any of these should go into 2.6.30, or earlier?
> 
> The patches are desirable for 2.6.30 but nothing earlier.

Everyone "desires" that their patches be merged immediately ;)

After -rc1 we're really only looking for bugfixes and regression fixes.
But afaict the only patch in this series which matches that guideline
is gru-bug-fixes-for-gru-exception-handling.patch?
