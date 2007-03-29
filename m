Return-Path: <linux-kernel-owner+w=401wt.eu-S1030680AbXC2UPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680AbXC2UPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030667AbXC2UPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:15:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030680AbXC2UPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:15:23 -0400
Date: Thu, 29 Mar 2007 13:14:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kumar Gala <galak@kernel.crashing.org>
cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       chuckmeade@mindspring.com
Subject: Re: Please pull from 'for_linus' branch
In-Reply-To: <Pine.LNX.4.64.0703291434500.23408@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703291311110.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703291434500.23408@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Kumar Gala wrote:
> 
> Please pull from 'for_linus' branch of
> master.kernel.org/pub/scm/linux/kernel/git/galak/powerpc.git

Please don't do this to me.

 - give a valid URL! 

   You could have either added a "ssh://" to before that string, or used a 
   colon between the hostname and the path, but the URL you quoted is 
   broken.

 - put the branch-name after the URL on the same line, so that I can 
   cut-and-paste them together rather than separately (and so that I don't 
   miss the fact that it wasn't the default branch)

IOW, it should have said

  Please pull from the 'for_linus' branch at

	master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git for_linus

or something similar.

Thanks from your anal and grumpy kernel maintainer,

		Linus
