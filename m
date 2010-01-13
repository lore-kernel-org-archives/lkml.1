Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205Ab0AMR3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0AMR3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167Ab0AMR3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:29:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58781 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756165Ab0AMR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:29:08 -0500
Date: Wed, 13 Jan 2010 12:29:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Julia Lawall <julia@diku.dk>,
       =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       David Vrabel <david.vrabel@csr.com>, <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, <cocci@diku.dk>
Subject: Re: Changelog quality
In-Reply-To: <4B4DFD87.3000904@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.1001131225160.3518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Stefan Richter wrote:

> If it was by mistake, inclusion of the find-and-replace script into the
> patch posting *after the --- delimiter* might have increased the chance
> that a patch reviewer becomes aware of a possible error source
> (inadequate match patterns...).  So that could be useful during review
> before commit, but not so much if the change is revisited some time
> after commit.

Somewhat tangentially, it's worth mentioning that the comments
appearing after the "---" delimiter exist only in the original patch
submissions, not in the final commits.  Hence they are not available to
anyone reviewing the changes after acceptance.

It would be nice if there was a way to link automatically a git commit
to an archived copy of the email message in which it was originally 
submitted.

Alan Stern

