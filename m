Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYKGBXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYKGBXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYKGBXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:23:38 -0500
Received: from waste.org ([66.93.16.53]:53191 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYKGBXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:23:38 -0500
Subject: Re: iwlagn: wrong command queue 31, command id 0x0
From: Matt Mackall <mpm@selenic.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1226020422.2604.148.camel@debian.sh.intel.com>
References: <1225944979.3792.3.camel@calx>
	 <1226020422.2604.148.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 19:23:08 -0600
Message-Id: <1226020988.3023.54.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 09:13 +0800, Zhu Yi wrote:
> On Thu, 2008-11-06 at 12:16 +0800, Matt Mackall wrote:
> > As of 75fa67706cce5272bcfc51ed646f2da21f3bdb6e, I'm seeing this:
> 
> On which git repo? I couldn't find the commit on either linux-2.6 or
> wireless-testing/-2.6.

Appears to be the head of Linus' tree:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75fa67706cce5272bcfc51ed646f2da21f3bdb6e

-- 
Mathematics is the supreme nostalgia of our time.

