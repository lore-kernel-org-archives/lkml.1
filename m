Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZI3Py6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZI3Py6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZI3Py6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:54:58 -0400
Received: from xenotime.net ([72.52.64.118]:52589 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754711AbZI3Py5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:54:57 -0400
Date: Wed, 30 Sep 2009 08:55:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andy <genanr@emsphone.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How can I download a git commit as a diff patch?
Message-Id: <20090930085500.a5856301.rdunlap@xenotime.net>
In-Reply-To: <20090930154410.GA31502@thumper2>
References: <20090930154410.GA31502@thumper2>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 10:44:10 -0500 Andy wrote:

> I just want to down a particular git commit as a patch, not a git commit or
> anything.  Yes, I can see the diffs on the web, but unless I am missing
> something all are in unless html formats for me.  And cut and past from the
> web page does not help either because some lines get mangled.  Is there some
> site, or git itself, that would allow be to get the git commit as a simple
> patch?

Look at the commitdiff using the web interface, then click on "raw" near
the upper left corner.

---
~Randy
