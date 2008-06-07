Return-Path: <linux-kernel-owner+w=401wt.eu-S1763974AbYFGTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974AbYFGTA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbYFGTAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:00:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759343AbYFGTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:00:21 -0400
Date: Sat, 7 Jun 2008 11:59:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mzxreary@0pointer.de
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook
 Pros
Message-Id: <20080607115953.5a2ec703.akpm@linux-foundation.org>
In-Reply-To: <84144f020806070305q33dd341wfbb36138d7b533a@mail.gmail.com>
References: <20080607025436.GB24254@srcf.ucam.org>
	<20080606230745.304d116b.akpm@linux-foundation.org>
	<20080607095839.GA803@srcf.ucam.org>
	<84144f020806070305q33dd341wfbb36138d7b533a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2008 13:05:23 +0300 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi Matthew,
> 
> On Fri, Jun 06, 2008 at 11:07:45PM -0700, Andrew Morton wrote:
> >> Did this patch have appropriate attribution and signoffs?
> 
> On Sat, Jun 7, 2008 at 12:58 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Pommed is GPLv2.
> 
> Andrew has required signoffs from all copyright holders of a patch in
> the past regardless of that.

More like "asked for".  It's best to gather those signoffs if the
people are around.

Getting the From: correct is (IMO) more important.
