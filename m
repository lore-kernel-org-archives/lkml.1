Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbXFLVGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbXFLVGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXFLVGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:06:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbXFLVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:06:01 -0400
Date: Tue, 12 Jun 2007 14:05:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/2] UML - Remove PAGE_SIZE from libc code
Message-Id: <20070612140544.40123d0c.akpm@linux-foundation.org>
In-Reply-To: <20070612164806.GA7517@c2.user-mode-linux.org>
References: <20070612164806.GA7517@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 12:48:06 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> Distros seem to be removing PAGE_SIZE from asm/page.h

They do?  That seems like a strange thing to do.  I wonder why, and I
wonder why such a change isn't needed in the mainline tree.
