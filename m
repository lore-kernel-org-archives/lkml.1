Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbZAKGrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbZAKGrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZAKGrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:47:13 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18515 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZAKGrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:47:13 -0500
Date: Sun, 11 Jan 2009 07:47:11 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
cc: linux-kernel@vger.kernel.org
Subject: Re: your mail
In-Reply-To: <204164.94418.qm@web34403.mail.mud.yahoo.com>
Message-ID: <alpine.LNX.2.00.0901110738550.21183@swampdragon.chaosbits.net>
References: <204164.94418.qm@web34403.mail.mud.yahoo.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Jose Luis Marchetti wrote:

> Hi,
> 
> I would like to open/read/write/close a regular file from my device
> driver.

That's probably a bad idea and what you really want to do is use procfs, 
sysfs, debugfs, relayfs, module parameters or similar.

Take a look here: 
http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad 


-- 
Jesper Juhl <jj@chaosbits.net>        http://personal.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

