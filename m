Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZLAHnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZLAHnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZLAHng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:43:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbZLAHng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:43:36 -0500
Subject: Re: [PATCH] param: don't complain about unused module parameters.
From: Adam Williamson <awilliam@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <200912011456.44457.rusty@rustcorp.com.au>
References: <200912011456.44457.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 30 Nov 2009 23:42:51 -0800
Message-Id: <1259653371.487.4.camel@adam.local.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 14:56 +1030, Rusty Russell wrote:
> Jon confirms that recent modprobe will look in /proc/cmdline, so these
> cmdline options can still be used.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=14164

Thanks for the fix, Rusty. This'll save a lot of confusion :)

-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Fedora Talk: adamwill AT fedoraproject DOT org
http://www.happyassassin.net

