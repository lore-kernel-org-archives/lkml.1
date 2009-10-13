Return-Path: <linux-kernel-owner+w=401wt.eu-S934027AbZJMSUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027AbZJMSUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbZJMSUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:20:15 -0400
Received: from vena.lwn.net ([206.168.112.25]:57636 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933561AbZJMSUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:20:14 -0400
Date: Tue, 13 Oct 2009 12:19:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] GPIO: Add gpio_lookup
Message-ID: <20091013121936.4b1a16c6@bike.lwn.net>
In-Reply-To: <20091013110507.a576310a.akpm@linux-foundation.org>
References: <20091010134814.0bac8624@bike.lwn.net>
	<20091013110507.a576310a.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 11:05:07 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'll assume the printk wasn't supposed to be there.

Really?  I shouldn't fill everybody's logs with my silly debugging
output?

I blame the Death Flu that my kids brought home.  Sorry.

jon
