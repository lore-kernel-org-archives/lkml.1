Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZJEHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZJEHyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbZJEHyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:54:11 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44038 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbZJEHyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=l9RXT6PGhiaBgfbR5C88Tz3l6dX7jWVSnQBmyNArsUrMggu6mrPMaDaUQsfMA0nUUg
         +z0jDeX1Je8E+YElyY+GIVbJnlBsH5gX3CFK0eXbDtzZoxSar4n2LlQq5wjOHLsDAo9V
         3IolizdUKDrRGXmdDde2rdp+xlHTc0CvmU/Bo=
Date: Mon, 5 Oct 2009 09:53:27 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.32-rc1: various BUGs on resume from hibernation
Message-ID: <20091005095327.5ea9831b@strolchi>
In-Reply-To: <200910042247.43528.rjw@sisk.pl>
References: <4AC8B4A8.3050601@tuffmail.co.uk>
	<4AC8D568.9090103@tuffmail.co.uk>
	<200910042247.43528.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.11; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Oct 2009 22:47:43 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Sunday 04 October 2009, Alan Jenkins wrote:
> > Alan Jenkins wrote:
> > > I'm seeing a variety of BUGs on my EeePC 701 after hibernation.  
> > > Sometimes they cause a hang during resume; sometimes they happen
> > > just after resume.  It doesn't happen all the time either -  I've
> > > just hibernated three times in a row with no problems.  It's most
> > > perplexing.

> As I already asked in the Bugzilla, can you verify that this is
> reproducible without KMS?

This is important, there *are* hibernation issues with intel/KMS,
e.g. http://bugs.freedesktop.org/show_bug.cgi?id=23701
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out." 
