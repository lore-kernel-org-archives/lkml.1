Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbYCSWzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbYCSWzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966221AbYCSVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:23:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966214AbYCSVXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:23:21 -0400
Date: Wed, 19 Mar 2008 14:21:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "john stultz" <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
       giometti@linux.it
Subject: Re: LinuxPPS (RESUBMIT 2): the PPS Linux implementation.
Message-Id: <20080319142113.a1e76213.akpm@linux-foundation.org>
In-Reply-To: <1f1b08da0803191029w6878f693l6ac24f974a088676@mail.gmail.com>
References: <12048053463198-git-send-email-giometti@linux.it>
	<1f1b08da0803191029w6878f693l6ac24f974a088676@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 10:29:34 -0700
"john stultz" <johnstul@us.ibm.com> wrote:

> On Thu, Mar 6, 2008 at 5:08 AM, Rodolfo Giometti <giometti@linux.it> wrote:
> > This patch set adds the PPS support into Linux.
> >
> >  PPS means "pulse per second" and its API is specified by RFC 2783
> >  (Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).
> >
> >  The code has been tested with the NTPD program
> >  (http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
> >  antennae.
> 
> Hey Andrew,
>   Are there any remaining objections that are keeping you from picking
> this patchset up?

Not as far as I know.  They're in my queue-to-review.  Assistance there is
always useful ;)

