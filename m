Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0BNSXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:23:52 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:46476 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0BNSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:23:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ue6AwqkbEhb8G7Yoy3AeiZecQqdWqbqnVQmX9cWR30YGq8XetRIyvgcZMaCi92WW6y
         bF0FvXxxj6G5f0Gd9JvFvxJtoZ8rpQzuBJfJpUtvv6X7zcBZ0vBSvaYtyrqS/EJ616nq
         rcjv2Gew+FskkPtG01YZH1cWh6kuPPQaswQP0=
MIME-Version: 1.0
Date: Sun, 14 Feb 2010 10:23:50 -0800
Message-ID: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
Subject: reiserfs issue with 2.6.32.8
From: Bret Towe <magnade@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently attempted upgrading from 2.6.31.6 to 2.6.32.8 on a local server
that runs several filesystems and when trying to move or copy or create a file
on a reiserfs system that was sitting on lvm over raid5(not sure if
that matters)
I would get mv or cp to return Invalid Argument and not doing anything
moving files from xfs to xfs worked fine tho

for now I went back to .31.6 I'm willing to test any patches required
any config info or what not let me know and I'll dig it up
dmesg was clean
