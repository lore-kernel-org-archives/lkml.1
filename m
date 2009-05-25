Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZEYPBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZEYPBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZEYPBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:01:13 -0400
Received: from vena.lwn.net ([206.168.112.25]:36090 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZEYPBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:01:12 -0400
Date: Mon, 25 May 2009 09:01:12 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Rik van Riel <riel@redhat.com>
Cc: John Walsh <server422@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: What Distro is best for Starting Kernel Dev?
Message-ID: <20090525090112.3919d117@bike.lwn.net>
In-Reply-To: <4A1819CB.9010104@redhat.com>
References: <9f7f2c020905221910m2ffe4c53v8fd5dbc6cd236602@mail.gmail.com>
	<4A1819CB.9010104@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 May 2009 11:44:11 -0400
Rik van Riel <riel@redhat.com> wrote:

> John Walsh wrote:
> > What Distro is best for Starting Kernel Dev?  
> 
> If you want to learn more about the system than
> anybody should ever need to know, you can stick
> with a bleeding-edge development distro like
> Fedora Rawhide, Mandriva Cooker or Debian Unstable.

I do the bulk of my work on such distributions, but if you're really
wanting to get started with *kernel* development, there is one thing to
be aware of: development distributions can be an independent source of
instability/weirdness in a system.  If you're at an early stage with the
kernel, you may want to minimize the number of variables which can be
changing at once.  So it might make more sense to base your work on a
distribution which is not changing underneath you.

jon
