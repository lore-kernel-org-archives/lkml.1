Return-Path: <linux-kernel-owner+w=401wt.eu-S936218AbXJQDj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936218AbXJQDj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbXJQDjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:39:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758291AbXJQDjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:39:19 -0400
Date: Tue, 16 Oct 2007 20:38:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Simon Horman <horms@verge.net.au>, vgoyal@in.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, hbabu@us.ibm.com, ebiederm@xmission.com
Subject: Re: [PATCH] [275/2many] MAINTAINERS - KDUMP
Message-Id: <20071016203810.00cda8ed.akpm@linux-foundation.org>
In-Reply-To: <1192589134.9998.93.camel@localhost>
References: <46bffa99.nQ27DQOgkKo2uOy+%joe@perches.com>
	<46bffa8e.NHuk7h7puR+3eDXo%joe@perches.com>
	<20071017021902.GB6709@verge.net.au>
	<1192589134.9998.93.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 19:45:34 -0700 Joe Perches <joe@perches.com> wrote:

> If one of the maintainers, Vivek Goyal or Haren Myneni, cared
> to improve the kdump list of files, I'd happily accept it.

meh.  Bug-reporters only manage to cc the right mailing list 10% of the
time even when it's utterly obvious which subsystem went splat.  I wouldn't
worry about fine details such as this.

Anyway, everyone just sends stuff to the great kernel routing service (ie:
me) for the traditional forward-and-ignore treatment.
