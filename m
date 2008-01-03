Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYACLP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYACLP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYACLPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:15:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35084 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYACLPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:15:47 -0500
Date: Thu, 3 Jan 2008 11:15:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: malattia@linux.it, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, trivial@kernel.org
Subject: Re: struct should not be named same way as function in sony-laptop
Message-ID: <20080103111543.GS27894@ZenIV.linux.org.uk>
References: <20080103110154.GA2376@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103110154.GA2376@elf.ucw.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 12:01:54PM +0100, Pavel Machek wrote:
> Naming struct and function by same name is evil. Rename the struct.

Um... why?  It's not even particulary bad style per se...  Occurs less
frequently than things like
	struct foo *foo;
but nothing inherently terrible and not likely to cause any kind of
confusion.
