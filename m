Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYKBSFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYKBSFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYKBSBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:01:47 -0500
Received: from smtp2.ono.com ([62.42.230.20]:18938 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754517AbYKBSBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:01:38 -0500
Date: Sun, 2 Nov 2008 19:01:29 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Strange fileystem problem
Message-ID: <20081102190129.00639ddb@werewolf.home>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have an strange problem. I ask here because it's related to sysfs and
filesystems...

I scp'd an untarred src tree of udev. That tree contains a link or something
like that of /sys. When I scpd it to other box, the symlinks like 'bus' in
the test/sys directory got derreferenced and I have an infinite depth tree
of directories in the dest machine.

Someone knows how to delte it ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
