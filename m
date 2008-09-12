Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYILOyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYILOyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYILOye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:54:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbYILOyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:54:33 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Christoph Hellwig <hch@infradead.org>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Fri, 12 Sep 2008 10:51:16 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <200809120216.31153.j@jannau.net> <20080912083332.GA29577@infradead.org>
In-Reply-To: <20080912083332.GA29577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121051.17424.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008 04:33:32 Christoph Hellwig wrote:
> On Fri, Sep 12, 2008 at 02:16:30AM +0200, Janne Grunau wrote:
> > I'm pretty sure LIRC will be recognized by its current users, it is
> > probably enough if it is in the help text though.
>
> But we don't care just for your current users :)  Kernel features /
> drivers do need good descriptions.

I'll work on that, as well as some less terse help texts.

[...wait queue and lifetime bits snipped, Janne's handling 'em...]

> And btw, any chance for an s/plugin/driver/g - that's the terminology
> we use everywhere else in the kernel.

Done. (will push after doing a quick sanity build-test to make sure I didn't 
miss anything)

-- 
Jarod Wilson
jarod@redhat.com

