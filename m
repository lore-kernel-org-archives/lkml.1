Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYKPWKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYKPWKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYKPWKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:10:36 -0500
Received: from vena.lwn.net ([206.168.112.25]:58246 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbYKPWKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:10:35 -0500
Date: Sun, 16 Nov 2008 15:10:19 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: "=?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/branch-tracer: Fix a trace recursion on
 branch tracer
Message-ID: <20081116151019.5ee745f6@tpl>
In-Reply-To: <c62985530811160601j1f1fb09cy7a1ad63b373b85b3@mail.gmail.com>
References: <491FA8C8.1040905@gmail.com>
	<20081116062213.GA32215@elte.hu>
	<c62985530811152232q2794ce1o6732c241821c6eca@mail.gmail.com>
	<20081116064948.GD32215@elte.hu>
	<c62985530811160601j1f1fb09cy7a1ad63b373b85b3@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 15:01:24 +0100
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> Ok. Yeah I had some trouble with this "impact" tag, finding it hard to
> not overlap its message with this of the patch's subject but I better
> understand now...
> Perhaps this tag should be explained in
> Documentation/development-process/5.Posting and SubmittingPatches...
> (cc-ed Jonathan for the development-process documents)....

I'll happily do so.  I will confess, though, that I don't really
understand how that tag differs from the information which simply
belongs in the patch title and changelog.  

jon
