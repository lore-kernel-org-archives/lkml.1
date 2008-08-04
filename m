Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbYHDWmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbYHDWmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYHDWkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:40:05 -0400
Received: from vena.lwn.net ([206.168.112.25]:47857 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbYHDWkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:40:04 -0400
Date: Mon, 4 Aug 2008 16:40:01 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       Jochen =?ISO-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>
Subject: Re: [PATCH] A development process document, V2
Message-ID: <20080804164001.57938f3f@bike.lwn.net>
In-Reply-To: <20080804131739.GH6088@cs181140183.pp.htv.fi>
References: <20080731111443.2179bf4c@bike.lwn.net>
	<20080804131739.GH6088@cs181140183.pp.htv.fi>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 16:17:39 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> Documentation/HOWTO roughly aimed at the same.
> 
> What's the intended relation between the two documents?

Documentation/HOWTO is a terse collection of useful tips.  It's a great
reference for people who have an idea of what they are doing and need
to come quickly up to speed.

This document is intended to be a much more comprehensive introduction
accessible to new developers and managers.  It is, I hope, something we
will be able to hand to companies which are trying to figure out how to
join in.  I don't expect it to replace Documentation/HOWTO, but I do
hope it will be more useful for a lot of the folks who most need this
kind of information.

Thanks,

jon
