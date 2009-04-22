Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZDVSzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZDVSzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDVSyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:54:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42869 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZDVSyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:54:52 -0400
Date: Wed, 22 Apr 2009 19:54:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 1/3] crc-itu-t: add bit-reversed calculation
Message-ID: <20090422185446.GA3051@decadent.org.uk>
References: <1239590017.18110.120.camel@deadeye.i.decadent.org.uk> <20090422165633.GD19524@kroah.com> <50558A33EC%linux@youmustbejoking.demon.co.uk> <20090422184409.GB2872@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422184409.GB2872@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 11:44:09AM -0700, Greg KH wrote:
> On Wed, Apr 22, 2009 at 07:32:23PM +0100, Darren Salt wrote:
> > I demand that Greg KH may or may not have written...
> > 
> > > On Mon, Apr 13, 2009 at 03:33:37AM +0100, Ben Hutchings wrote:
> > >> Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
> > 
> > > Who wrote this patch, you or Darren?
> > 
> > I did.
> 
> Thanks.
> 
> Then Ben should keep that authorship information properly when he
> forwards patches onward.  You can do this by putting:
> 	From: Darren Salt <email_address_here>
> as the first line in the body of the email.  Our tools will properly
> pick it up there and give the correct attribution.
> 
> Ben, does this make sense?
 
Yes, that's what I usually do with other people's patches.  It was an
oversight in this case.

Ben.

-- 
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.
