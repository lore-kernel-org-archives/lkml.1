Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbYAMPfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYAMPfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 10:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYAMPfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 10:35:46 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:3556 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751561AbYAMPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 10:35:45 -0500
Date: Sun, 13 Jan 2008 16:35:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH] update module-init-tools to support the i2c
 subsystem
Message-ID: <20080113163543.16e3d26b@hyperion.delvare>
In-Reply-To: <9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
References: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
	<20080113152735.5dca46a1@hyperion.delvare>
	<9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 10:14:14 -0500, Jon Smirl wrote:
> On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > On Mon, 17 Dec 2007 21:39:37 -0500, Jon Smirl wrote:
> > > Follow on to: "Series to add device tree naming to i2c"
> > > Teach module-init-tools about the i2c subsystem.
> >
> > Can you please explain what this patch does and why it is needed?
> 
> It generates the entries needed for the user space module tools to
> work with the aliases. For example modprobe/depmod. It is a standard
> part of the kernel module system.

What entries, where? What can you do after applying your patch that you
couldn't do before?

I'm asking because automatic i2c driver loading works just fine for me
without patching user-space. So I don't get why your want to change
anything.

-- 
Jean Delvare
