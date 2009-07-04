Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZGDOlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZGDOlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 10:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZGDOlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 10:41:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbZGDOlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 10:41:00 -0400
Subject: Re: kernel BUG at fs/notify/notification.c:93!
From: Eric Paris <eparis@redhat.com>
To: "Mikko C." <mikko.cal@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <4A4F0FD4.7070009@gmail.com>
References: <4A4F0FD4.7070009@gmail.com>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 10:40:55 -0400
Message-Id: <1246718455.20265.2.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-04 at 10:16 +0200, Mikko C. wrote:
> Hi,
> since upgrading to 2.6.31-rc1 I randomly get this:
> 
> kernel BUG at 
> fs/notify/notification.c:93!  

This is the first time I've heard about it.  I'm looking for the problem
but I don't see it right offhand.  Is there anything you know of that
causes it?  I'm looking though....

-Eric

