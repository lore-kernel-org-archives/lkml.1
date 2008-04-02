Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbYDBSXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbYDBSXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYDBSXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:23:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:38016 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYDBSXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UuQ1vzY6TUQOYFSrAT9YMJJqHIx2Ut8R9Rfc/pDz+801jFbY4ASKuVIKgbFkoUBTDRks/OOt8thCrcMdvN0jciWJbh0BNasy0PuR3uwqXCmRuiAwkaGbzeFPIaNzi5uxsJ3U0NmrXWMROAOqHRA5BAMdyOSn8YSSeepAG1iqtno=
Date: Wed, 2 Apr 2008 20:26:55 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: seraph@xs4all.nl, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Fwd: [SPARC64] INO problem Re: [Bug 10273] New: Sun GEM (PCI) -
	network device doesn't work
Message-ID: <20080402182655.GA2739@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317143624.da313311.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nice work Jos! I forward it to the author and the lists.

Jarek P.

Andrew Morton wrote, On 03/17/2008 10:36 PM:

> On Mon, 17 Mar 2008 14:25:50 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=10273
>>
>>            Summary: Sun GEM (PCI) - network device doesn't work

----- Forwarded message from bugme-daemon@bugzilla.kernel.org -----

> ------- Comment #24 from seraph@xs4all.nl  2008-04-02 07:24 -------
> I did bisection. The bad commit is:
> 
> 5a606b72a4309a656cd1a19ad137dc5557c4b8ea is first bad commit
> commit 5a606b72a4309a656cd1a19ad137dc5557c4b8ea
> Author: David S. Miller <davem@sunset.davemloft.net>
> Date:   Mon Jul 9 22:40:36 2007 -0700
> 
>     [SPARC64]: Do not ACK an INO if it is disabled or inprogress.
> 
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.

----- End forwarded message -----
