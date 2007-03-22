Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbXCVRur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbXCVRur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934158AbXCVRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:50:47 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934152AbXCVRuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:50:46 -0400
Date: Thu, 22 Mar 2007 09:50:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [ PATCH 0/7 ] UML - Header cleanup
Message-Id: <20070322095034.51a16aa5.akpm@linux-foundation.org>
In-Reply-To: <20070322160640.GA6992@c2.user-mode-linux.org>
References: <20070322160640.GA6992@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 12:06:40 -0400 Jeff Dike <jdike@addtoit.com> wrote:

> These are post-2.6.21 material, except that if the new definition of
> ARRAY_SIZE goes to Linus, patch 1 in this series should go as well.

I have the ARRAY_SIZE change queued for 2.6.22.

It looks like the UML change needs to be folded into the same changeset to
avoid build breaks?

