Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbYANVyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbYANVyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYANVxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:53:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610AbYANVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:53:36 -0500
Date: Mon, 14 Jan 2008 13:52:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: dds@google.com, pavel@ucw.cz, shpedoikal@gmail.com, tpm@selhorst.net,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] - TPM save state before suspending to ram
Message-Id: <20080114135223.bcee353a.akpm@linux-foundation.org>
In-Reply-To: <200801142240.59174.rjw@sisk.pl>
References: <477D491F.1060001@selhorst.net>
	<20080104234413.GB800@elf.ucw.cz>
	<200801051354.37843.dds@google.com>
	<200801142240.59174.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 22:40:58 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > >
> > > Yep, but please fix the whitespace.
> > > 									Pavel
> > 
> > OK, attached.
> 
> Is anyone taking care of this patch or should I do that?

Linus just merged it as 2490c681ea3d7f5ac3fb876f14567bf1a9e0aa87.  That's
if we're talking about the same thing (there were a few iterations). 
