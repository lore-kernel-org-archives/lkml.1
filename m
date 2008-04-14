Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbYDNNwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbYDNNwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYDNNwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:52:04 -0400
Received: from vena.lwn.net ([206.168.112.25]:35147 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbYDNNwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:52:03 -0400
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 14 Apr 2008 06:33:09 +0400."
             <4802C265.8060802@gmail.com> 
Date: Mon, 14 Apr 2008 07:52:00 -0600
Message-ID: <28421.1208181120@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Offhand, it seems that the double spacing convention is being currently used
> in a more or less consistent manner throughout Linux docs. It also seems to
> me that this can be made a requirement and documented somewhere.

Double spacing is my preference, and I appreciate your sending a new
patch which doesn't take that out.

But *please* let's not try to make "requirements" along those lines.  If
somebody's going to go to the trouble to write some documentation, I
don't think we really want people bouncing it back to them with 100
"single space after period" errors from checkpatch.pl...

Thanks,

jon
