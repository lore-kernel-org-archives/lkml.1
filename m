Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbYDUT6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbYDUT6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbYDUT6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:58:40 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:62569 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756814AbYDUT6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:58:39 -0400
From: fox@crisp.demon.co.uk
To: bart.vanassche@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: dtrace for linux
Date: Mon, 21 Apr 2008 20:58:25 +0100
User-Agent: Demon-WebMail/2.0
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Message-Id: <E1Jo29h-0004Ku-1i@pr-webmail-1.mail.demon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sun, Apr 20, 2008 at 1:17 AM,  <fox@crisp.demon.co.uk> wrote:
> >
> >  I would like to announce that I am working on dtrace for Linux.
> >  I have the userland dtrace binary compiled, along with the first
> >  pre-pre-alpha dtracedrv.ko module loaded into my kernel.
> 
> This is great news. How will this dtrace implementation differ from
> SystemTap (http://sourceware.org/systemtap/) ?
> 
> Bart.
> 
> 

Hello Bart,


I dont know systemtap all that well, other than what i have
read on the net and browsed in the source. systemtap is similar,
but dtrace provides a high level functional language (D) and
a set of methodologies and scripts which mean learning/training
will make it easier to use.

In addition, dtrace promises to be kernel safe (whether or not it
is will be down to how good a job I do I guess!)



