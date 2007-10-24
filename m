Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXJXO1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXJXO1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXJXO1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:27:32 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42921 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbXJXO1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:27:31 -0400
Date: Wed, 24 Oct 2007 08:27:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
Message-ID: <20071024142729.GZ27248@parisc-linux.org>
References: <471E6313.1040704@garzik.org> <1193174424.3434.3.camel@localhost.localdomain> <471E707B.1020505@garzik.org> <20071023.153635.21595587.davem@davemloft.net> <1193232490.3396.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193232490.3396.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:28:10AM -0400, James Bottomley wrote:
> OK, so it's no secret that I'm the last of the subsystem maintainers
> whose day job isn't working on the linux kernel.  If you want a full
> time person, who did you have in mind?

I'm willing to take on the role of scsi git-monkey.  Alternatively, we
could split the scsi maintainer role the same way that Dave and Jeff
do for net where Dave handles the core and Jeff handles the drivers.
Or we can negotiate some other arrangement.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
