Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbZJPMhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbZJPMhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759022AbZJPMhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:37:40 -0400
Received: from lucidpixels.com ([75.144.35.66]:50699 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759019AbZJPMhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:37:40 -0400
Date: Fri, 16 Oct 2009 08:37:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 2.6.31: xfs or md/raid1 bug in 2.6.31?
Message-ID: <alpine.DEB.2.00.0910160832290.31450@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Does anyone recall if there was a serious xfs bug in 2.6.31?

I saw xfsbufd/pdflush etc locked up and local file system access hung 
whenever I tried to write a file to the filesystem, I ran a sysrq-t but 
could not capture the output nor did I see anything obvious.

System runs a md/raid1+xfs.

Upgraded to 2.6.31.4, will have to see if it happens again.

Was curious though if anyone recalled problems with this kernel 
release/combination?

Thanks,

Justin.
