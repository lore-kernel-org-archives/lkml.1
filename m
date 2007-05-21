Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXEUGc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXEUGc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXEUGct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:32:49 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:53543 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbXEUGcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:32:48 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705210632.l4L6Wkt0004225@turbo.physics.adelaide.edu.au>
Subject: Re: 2.6.21.1 on Fedora Core 6 breaks LVM/vgscan
To: linux-kernel@vger.kernel.org
Date: Mon, 21 May 2007 16:02:46 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2007 I wrote:

> Attempting to compile a 2.6.21.1 kernel for use on a Fedora Core 6 box
> results in a panic at boot because the root filesystem can't be found.

I have just compiled 2.6.22-rc2 with the configuration file given in my
previous post and the resulting kernel successfully boots on the machine
concerned.  Whatever broke LVM for this machine in between 2.6.18 and
2.6.21.1 has now been fixed.

There is still a problem with the CDROM but I will follow up in another
thread about that.

Regards
  jonathan
--
"Time is an illusion; lunchtime doubly so"
