Return-Path: <linux-kernel-owner+w=401wt.eu-S965963AbXDGWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965963AbXDGWGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965955AbXDGWGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:06:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34785 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965958AbXDGWGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:06:42 -0400
Date: Sat, 7 Apr 2007 15:06:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Message-Id: <20070407150612.f99aae4a.akpm@linux-foundation.org>
In-Reply-To: <200704072320.40238.rjw@sisk.pl>
References: <200704072320.40238.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 23:20:39 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This should allow us to reduce the memory usage, practically always, and
> improve performance.

And does it?
