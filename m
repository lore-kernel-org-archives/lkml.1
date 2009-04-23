Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZDWVGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZDWVGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZDWVGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:06:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499AbZDWVGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:06:25 -0400
Date: Thu, 23 Apr 2009 14:01:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       rusty@rustcorp.com.au, mingo@elte.hu, kay.sievers@vrfy.org
Subject: Re: WARNING: at fs/sysfs/group.c:138 sysfs_remove_group
Message-Id: <20090423140103.2a73a897.akpm@linux-foundation.org>
In-Reply-To: <20090423203945.GA3890@kroah.com>
References: <c4e36d110904170213q24c2688ag9bcaa8562dddaa3f@mail.gmail.com>
	<20090423130930.50a6c9db.akpm@linux-foundation.org>
	<20090423203945.GA3890@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 13:39:45 -0700
Greg KH <greg@kroah.com> wrote:

> > But it seems that the sysfs_remove_group() later got removed again.
> 
> So, this is a microcode specific issue?

Don't know.  I cc'ed Rusty and ran away, as is my wont.
