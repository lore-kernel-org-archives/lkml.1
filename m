Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYHHCG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYHHCG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYHHCGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:06:48 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:44556 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbYHHCGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:06:48 -0400
Message-ID: <489BAA25.3030004@keyaccess.nl>
Date: Fri, 08 Aug 2008 04:06:29 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface	for
 on access scanning
References: <20080804223249.GA10517@kroah.com>	 <1217896374.27684.53.camel@localhost.localdomain>	 <20080805005132.GA3661@kroah.com>	 <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>	 <20080805170307.GB9639@kroah.com>	 <1217962602.27684.144.camel@localhost.localdomain>	 <20080805203007.GB27489@kroah.com>	 <1218048597.27684.276.camel@localhost.localdomain>	 <20080806210202.GA9413@mit.edu>	 <1218058081.5837.49.camel@localhost.localdomain>	 <20080806215244.GA21462@mit.edu> <1218118603.5837.101.camel@localhost.localdomain>
In-Reply-To: <1218118603.5837.101.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-08-08 16:16, Eric Paris wrote:

> Absolutely, I think that our solution needs worry much less about an 
> actively attacking root process than Windows.

Note by the way that this assumption is being actively undermined by all 
those companies releasing software released as big executable blobs that 
you just have to chmod +x and run; as root if you want them in /opt, or 
/usr/local/bin, or ...

Even when OpenOffice.org, IBM Lotus Symphony, RealPlayer, Flash, what 
have you, might generally by themselves not be considered virusses both 
the precedent they set and the opportunity for infecting systems by 
offering those for re-download from elsewhere is worrying.

One of the more useful things the security crowd could do to keep the 
above assumption valid would be working on a general "external software 
installer" and getting all distributions to settle on it (which probably 
needs a common divisor package and distro backends to feed it to the 
native package manager).

Rene.
