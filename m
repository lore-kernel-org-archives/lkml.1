Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbYEKVR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbYEKVR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761613AbYEKVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:11:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55935 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761403AbYEKVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:11:15 -0400
Date: Sun, 11 May 2008 22:11:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [Bug #10557] [regression] latest git couse kernel oops.
Message-ID: <20080511211113.GL13907@ZenIV.linux.org.uk>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.1aB.Jx1JIB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88YBFoyd1CN.A.1aB.Jx1JIB@chimera>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:04:12PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10557
> Subject		: [regression] latest git couse kernel oops.
> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> Date		: 2008-04-26 00:19 (16 days old)

Changeset in question is a memory corruptor fixed almost immediately
afterwards.  So if that's where bisect _ends_, I'm afraid that this
is not the end of story.
