Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbXJZRB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbXJZRB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXJZRBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:01:47 -0400
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:40241 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753169AbXJZRBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:01:46 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Fri, 26 Oct 2007 09:59:45 -0700
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, torvalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com>
In-Reply-To: <20071026025407.GA21408@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260959.46811.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2007 7:54 pm Greg KH wrote:
> On Thu, Oct 25, 2007 at 04:22:35PM -0700, Jesse Barnes wrote:
> > I think Greg doesn't like it, even though we don't have an
> > alternative at this point...
>
> Yes, I didn't like it, Ivan didn't like it, and I got reports that it
> wasn't even needed at all once you upgraded your BIOS to the latest
> version.
>
> So, is this still needed?  And if so, can you try to implement what
> Ivan suggested to do here instead?

Yes, it's still needed.  Auke rescinded his "BIOS upgrade makes it work" 
message, so something like this is still necessary.

Jesse
