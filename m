Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYBHNzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYBHNzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbYBHNyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:54:53 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:58410 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbYBHNyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:54:53 -0500
To: ael <law_ence.dev@ntlworld.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git tree urls
References: <foheti$vgb$1@ger.gmane.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Feb 2008 14:38:33 +0100
In-Reply-To: <foheti$vgb$1@ger.gmane.org>
Message-ID: <87abmb36w6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Feb 2008 13:32:13.0813 (UTC) FILETIME=[03C6FA50:01C86A57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ael <law_ence.dev@ntlworld.com> writes:

Mr. Anonymous,

> I have trouble locating some of the git urls (the mm repository, for
> example). I have browsed around
> http://www.kernel.org/pub/scm/linux/kernel/git/,
> consulted the kernel FAQ, and read the obvious links on www.kernel.org.
> 
> git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.x.y.git is easy
> to find, and I would guess that the main development repository is
> pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
> but that is speculation.
> 
> Can someone who knows take a minute or two to put a note of the main
> urls on www.kernel.org or the FAQ, or have I just missed something?

-mm is not maintained in git, but in quilt format.  The latest version is 
on the ftp server in akpm's people directory.

-Andi
