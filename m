Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbXJZRAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbXJZRAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbXJZRAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:00:05 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:33904 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764461AbXJZRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:00:00 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: - mmconfig-validate-against-acpi-motherboard-resources.patch removed from -mm tree
Date: Fri, 26 Oct 2007 09:58:01 -0700
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, torvalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <47217537.3050905@shaw.ca> <20071026052754.GA23116@kroah.com>
In-Reply-To: <20071026052754.GA23116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260958.02290.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2007 10:27 pm Greg KH wrote:
> On Thu, Oct 25, 2007 at 11:03:51PM -0600, Robert Hancock wrote:
> > Greg KH wrote:
> >> On Thu, Oct 25, 2007 at 04:22:35PM -0700, Jesse Barnes wrote:
> >>> I think Greg doesn't like it, even though we don't have an
> >>> alternative at this point...
> >>
> >> Yes, I didn't like it, Ivan didn't like it, and I got reports that
> >> it wasn't even needed at all once you upgraded your BIOS to the
> >> latest version.
> >> So, is this still needed?  And if so, can you try to implement
> >> what Ivan suggested to do here instead?
> >
> > Aren't you guys referring to
> > pci-disable-decode-of-io-memory-during-bar-sizing.patch? This is
> > another one entirely, though related.
>
> I have no idea, there have been a lot of conflicting patches in this
> area...

Oh sorry, my confusion.

I don't know what happened to the mmconfig vs. ACPI resources patch.

Jesse
