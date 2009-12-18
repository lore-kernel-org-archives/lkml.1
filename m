Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZLREXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZLREXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 23:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZLREXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 23:23:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:39471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZLREXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 23:23:10 -0500
Date: Thu, 17 Dec 2009 20:20:07 -0800
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/6] Driver core: Encourage use of const attributes
Message-ID: <20091218042007.GA6314@suse.de>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com> <20091217231621.GA5103@suse.de> <20091218114223.ca328c28.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218114223.ca328c28.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 11:42:23AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 17 Dec 2009 15:16:21 -0800 Greg KH <gregkh@suse.de> wrote:
> >
> > I'll be glad to take 1-3 now, and queue it up for .34.
> 
> Any reason not to ask Linus to take them for .33 - that way the
> conversions of callers can be done adhoc (and in more than just your
> tree) for .34.  These API changes should be perfectly safe (and the
> compiler should tell us if they are not).

Good idea, I'll queue them up to get in soon.

thanks,

greg k-h
