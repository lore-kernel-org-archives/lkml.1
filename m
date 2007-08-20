Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXHTTl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXHTTl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbXHTTlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:41:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756248AbXHTTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:41:20 -0400
Date: Mon, 20 Aug 2007 12:40:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 1/6] UML - Fix inlines
Message-Id: <20070820124030.d603b928.akpm@linux-foundation.org>
In-Reply-To: <20070817194340.GA8734@c2.user-mode-linux.org>
References: <20070817194340.GA8734@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 15:43:40 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> "extern inline" will have different semantics with gcc 4.3.

What are these different semantics?
