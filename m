Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYDJFsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYDJFsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 01:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYDJFsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 01:48:06 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:18412 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYDJFsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 01:48:05 -0400
Message-ID: <c42f92750804092248s548ebbam43e7724eed3eb25@mail.gmail.com>
Date: Thu, 10 Apr 2008 11:18:04 +0530
From: "Shakul Mohideen Hameed" <smohideen@blackhole.labs.rootshell.ws>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT] git-clone failure over http
In-Reply-To: <c42f92750804092213p7b2c5607sa48a83086d45a825@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c42f92750804092213p7b2c5607sa48a83086d45a825@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I learnt that

"....Linus packs his refs, which means that currently you can't clone using
http, with any version of git.
  -- quoted by Julian Philips"

I have to search Direct alternative... may be let me try through socks.

thanks, smohideen

On 4/10/08, Shakul Mohideen Hameed
<smohideen@blackhole.labs.rootshell.ws> wrote:
> I am getting errors while cloning few of the kernel sources over HTTP.
> Both proxy/direct modes are failing.
> Please advise.
>    - smohideen
>
>
> git version 1.5.0.6
>
>
> [moin@tb32-tgw1 linux-kernel]$ git-clone
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> Initialized empty Git repository in
> /home/moin/linux-kernel/linux-2.6-sched-devel/.git/
> Getting alternates list for
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git/
> Also look at http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
> Getting pack list for
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git/
> Getting index for pack ef5edbcc679c9e7e54731ae6e8835d1f9337cf60
> Getting pack list for
> http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
> error: Unable to find 7180c4c9e09888db0a188f729c96c6d7bd61fa83 under
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git/
> Cannot obtain needed object 7180c4c9e09888db0a188f729c96c6d7bd61fa83
>
