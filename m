Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYIMXfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYIMXfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 19:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYIMXex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 19:34:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40538 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYIMXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 19:34:53 -0400
Date: Sat, 13 Sep 2008 19:34:51 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: jmerkey@wolfmountaingroup.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's LinuxWare 1.0 MS-DOS Loader
In-Reply-To: <17946.166.70.238.45.1220845139.squirrel@webmail.wolfmountaingroup.com>
Message-ID: <alpine.LNX.1.10.0809131932560.16085@fbirervta.pbzchgretzou.qr>
References: <17946.166.70.238.45.1220845139.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-09-07 23:38, jmerkey@wolfmountaingroup.com wrote:

>I am pleased to announce the release of Merkey's LinuxWare, an MS-DOS (or
>DR-DOS) loader that allows you to compile a Linux kernel as an MS-DOS
>Executable, boot and load Linux from MS-DOS (while DOS stays resident).
>
>This in essence is exactly the same as old Legacy Netware, and in fact, I
>wrote a linker that does what the old NetWare custom linker did when it 
>compiled the NetWare kernel and linked it as a DOS Application.  Linux
>works
>just like it does normally, except you can quit Linux and exit back to  DOS.

So, just another UML architecture ;-)

But how much memory does it need? Raw Linux wants at least 5 MB.
