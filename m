Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbXA2UZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbXA2UZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXA2UZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:25:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbXA2UZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:25:47 -0500
Date: Mon, 29 Jan 2007 12:22:44 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Juju
Message-Id: <20070129122244.54fbcdfe.zaitcev@redhat.com>
In-Reply-To: <45BE50B8.2080001@redhat.com>
References: <20070124223745.33278eb4.zaitcev@redhat.com>
	<45B91EAB.9080004@redhat.com>
	<20070128161345.9dd3c086.zaitcev@redhat.com>
	<45BE50B8.2080001@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 14:53:28 -0500, Kristian Høgsberg <krh@redhat.com> wrote:

> >>    git://people.freedesktop.org/~krh/linux-2.6
> > 
> > This seems to have disappeared. Was it moved or dropped?
> 
> No, it's still there, and I just did a git clone on it.  How does it fail for 
> you?

Oh never mind, sorry. It said "Already up-to-date", but since HTTP
does not show it, I assumed it's not there.

>  In any case, you're probably better of pulling from Stefans kernel.org tree:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
> 
> since that's where new work is going to show up.  I'm still trying to figure 
> out a good workflow for this, but if all patches are going to through 
> linux1394-devel, there's not much point in me publishing a branch in the 
> freedesktop.org repo, if the patches are going to be edited/tweaked and the 
> committed to Stefans repo.

I see, thanks.

-- Pete
