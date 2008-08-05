Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYHEW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYHEW3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYHEW3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:29:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:42995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYHEW3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:29:06 -0400
Date: Tue, 5 Aug 2008 15:26:38 -0700
From: Greg KH <greg@kroah.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro
	toalinuxinterfaceforonaccess scanning
Message-ID: <20080805222638.GA6395@kroah.com>
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com> <20080805211445.GA28304@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com> <20080805214415.GA5830@kroah.com> <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 06:12:34PM -0400, Press, Jonathan wrote:
> Sorry for the top-post... but I give up.
>  
> I don't think I'm stupid, but frankly I don't understand the point of
> the questions being asked in the last three responses to my statement.
> I don't know why they are relevant, and I don't know how to answer
> them in a framework that we can all understand at the same time.  What
> is my threat model?  Naively stated, it is that there is a file on a
> machine that might do damage, either there or elsewhere, and I want to
> find it and get rid of it in the most efficient way.  I am not
> defining the nature of the damage or the mechanism.

If you can not define this, in a precise manner, then how can we expect
to review the proposed solution to ensure that it matches your needs?

Without that, this patchset is going to go nowhere but into the circular
bin :(

greg k-h
