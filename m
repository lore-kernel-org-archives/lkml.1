Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbXIVOXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbXIVOXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 10:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXIVOXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 10:23:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbXIVOXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 10:23:33 -0400
Date: Sat, 22 Sep 2007 10:23:25 -0400
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>, oliver.pntr@gmail.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
Message-ID: <20070922142325.GK11455@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@suse.de>,
	oliver.pntr@gmail.com, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200709221231.836138000@suse.de> <20070921223202.2504813DCD@wotan.suse.de> <20070921224539.GD8127@redhat.com> <20070922065724.GA26550@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922065724.GA26550@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 08:57:24AM +0200, Sam Ravnborg wrote:

 > > This seems like yet another list that will need to be perpetually
 > > kept up to date, and given 99% of users don't know the codename
 > > of their core, just the marketing name, I question its value.
 > 
 > As a bare minimum requirement the list presented here shall use same
 > names as used in /proc/cpuinfo
 > 
 > On this box I read:
 > 
 > vendor_id	: GenuineIntel
 > model name	: Pentium III (Coppermine)

There are *dozens* of possible entries here, and always new ones.
The list will become so cumbersome that searching for the name
through the help text of each possible option will become a
really boring task, that I doubt anyone will seriously do.

	Dave

-- 
http://www.codemonkey.org.uk
