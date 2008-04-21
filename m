Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYDUGm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYDUGm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYDUGmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:42:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42521 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYDUGmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:42:18 -0400
Date: Mon, 21 Apr 2008 07:42:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sys_indirect or many syscalls?
Message-ID: <20080421064205.GN27459@ZenIV.linux.org.uk>
References: <480C33E2.7060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C33E2.7060101@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 11:27:46PM -0700, Ulrich Drepper wrote:

> I still think the sys_indirect method is the best since it avoids bloat
> in the number of system calls.

The same could be (and had been) said about ioctl(2)...
