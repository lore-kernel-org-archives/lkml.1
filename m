Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbYFWRAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbYFWRAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYFWRAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:00:07 -0400
Received: from main.gmane.org ([80.91.229.2]:49801 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYFWRAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:00:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ian Soboroff <isoboroff@gmail.com>
Subject: Re: Oops in NFS (RHEL4, but also in kernel bugzilla)
Date: Mon, 23 Jun 2008 12:47:57 -0400
Message-ID: <9cfod5sayiq.fsf@rogue.ncsl.nist.gov>
References: <6278d2220806181933l74719bdbkea02f697ee424157@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: daniel.blueman@gmail.com
X-Gmane-NNTP-Posting-Host: rogue.ncsl.nist.gov
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.1.91 (darwin)
Cancel-Lock: sha1:+nmFkNNe9kZ+t7YqBzwMVsbsCFo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel J Blueman" <daniel.blueman@gmail.com> writes:

> Has 4KB stacks been disabled? You can check the config file for
> CONFIG_4KSTACKS.

This kernel has 4KSTACKS enabled.  

> It may also be worth feeding that into the bugzilla entry, to
> eliminate one possibility, as 'bad EIP value' looks suspicious of
> stack corrption.

Ok, will do.  Although that bugzilla entry is from 2007 and no one seems
to have looked at it at all...

Ian

