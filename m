Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYAGLhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYAGLhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYAGLhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:37:01 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:37557 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbYAGLhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:37:00 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 06:37:00 EST
Message-ID: <47820D24.3060800@fel.cvut.cz>
Date: Mon, 07 Jan 2008 21:29:40 +1000
From: Michal Simek <simekm2@fel.cvut.cz>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: monstr@monstr.eu
Subject: New linux arch
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I redesigned all files for microblaze cpu (xilinx fpga).
All code is FDT compatible.

I would like to ask you what is the best way to push these changes to 
kernel.org.

I would like to know step by step how to do.

I have some question about.

I have changes in my internal git repository. I don't have public git 
repository.
Is it possible to create git repository in git.kernel.org for Microblaze 
cpu?

What are maintainers responsibilities? Do you have any page about?
I am  U-BOOT maintainer at denx.de and I hope that the responsibilities 
will be similar.

How many maintainers are acceptable? (one or more)

I checked whole code with checkpatch.pl script to avoid code violations. 
I hope I resolve the most of coding style problems.

I see the right way to push all changes to public git repository and 
then send patches in small logical group to LKML with CC to people from 
microblaze community.

And then wait for comments from you, solve problems, update git 
repository and send changes again.

Thanks for your comments.

Cheers,
Michal Simek
