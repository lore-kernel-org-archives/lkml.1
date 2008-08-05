Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYHEX6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYHEX6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbYHEX6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:58:01 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43617 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756160AbYHEX57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:57:59 -0400
Date: Tue, 5 Aug 2008 19:57:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Greg KH <greg@kroah.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro
	toalinuxinterfaceforonaccess scanning
Message-ID: <20080805235733.GD8224@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Paris <eparis@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
	Greg KH <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org
References: <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com> <20080805211445.GA28304@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com> <20080805214415.GA5830@kroah.com> <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com> <20080805222638.GA6395@kroah.com> <20080805233743.GK28946@ZenIV.linux.org.uk> <1217980132.27684.203.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217980132.27684.203.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 07:48:52PM -0400, Eric Paris wrote:
> I do believe for a number of AV vendors the answer is yes.  I will try
> to have some offline conversations with the right people at a number of
> vendors and work to better define the threats that they wish to or
> believe they are able to help mitigate.

OK, and if the malware is running on the machine, does the malware
have root (superuser) access?

						- Ted
