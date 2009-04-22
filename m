Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZDVSuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZDVSuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZDVSul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:50:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:53658 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZDVSul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:50:41 -0400
Date: Wed, 22 Apr 2009 11:44:09 -0700
From: Greg KH <gregkh@suse.de>
To: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 1/3] crc-itu-t: add bit-reversed calculation
Message-ID: <20090422184409.GB2872@suse.de>
References: <1239590017.18110.120.camel@deadeye.i.decadent.org.uk> <20090422165633.GD19524@kroah.com> <50558A33EC%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50558A33EC%linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 07:32:23PM +0100, Darren Salt wrote:
> I demand that Greg KH may or may not have written...
> 
> > On Mon, Apr 13, 2009 at 03:33:37AM +0100, Ben Hutchings wrote:
> >> Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
> 
> > Who wrote this patch, you or Darren?
> 
> I did.

Thanks.

Then Ben should keep that authorship information properly when he
forwards patches onward.  You can do this by putting:
	From: Darren Salt <email_address_here>
as the first line in the body of the email.  Our tools will properly
pick it up there and give the correct attribution.

Ben, does this make sense?

thanks,

greg k-h
