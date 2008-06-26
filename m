Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYFZIiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYFZIiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYFZIiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:38:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56992 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYFZIiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:38:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 ACPI: normalize segment descriptor register on resume
Date: Thu, 26 Jun 2008 10:39:59 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200806242303.49498.rjw@sisk.pl> <20080626011716.e8c412dd.akpm@linux-foundation.org> <20080626082943.GC10973@elte.hu>
In-Reply-To: <20080626082943.GC10973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261040.00646.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 of June 2008, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Len seems to think that Rafael seems to think that Ingo seems to think 
> > that this patch broke one of his boxes.
> > 
> > Is it so?
> 
> No! :-)
> 
> it found a pre-existing suspend+resume breakage on a testbox. (I.e. the 
> debug patch worked as i'd expect it to work. Every good debug patch 
> starts its lifetime with a sharp spike of breakages it finds.)

Does it mean that the $subject patch doesn't break your test box after all?

Rafael
