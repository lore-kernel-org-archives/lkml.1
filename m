Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbXKTVis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbXKTVis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764228AbXKTVi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:38:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764151AbXKTVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:38:28 -0500
Date: Tue, 20 Nov 2007 13:37:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@tv-sign.ru, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] kill PT_PTRACED
Message-Id: <20071120133743.117c4e61.akpm@linux-foundation.org>
In-Reply-To: <20071120212851.EEB5026F8BE@magilla.localdomain>
References: <20071120152133.GA4546@tv-sign.ru>
	<20071120210840.94CB726F8BE@magilla.localdomain>
	<20071120212031.GA157@tv-sign.ru>
	<20071120212851.EEB5026F8BE@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 13:28:51 -0800 (PST)
Roland McGrath <roland@redhat.com> wrote:

> > Andrew, it is very easy to send the new patch to fix the code, but is it
> > possible to fix the changelog somehow for the patch in -mm tree?

Sure, just send me the new text.

> I'd prefer a comment in the code there making it explicit that ->sighand is
> a "reaped yet" synchronization check (under tasklist_lock).

that works too.
