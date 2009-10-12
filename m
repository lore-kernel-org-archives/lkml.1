Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbZJLWSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbZJLWSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZJLWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:18:05 -0400
Received: from kroah.org ([198.145.64.141]:36283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbZJLWSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:18:03 -0400
Date: Mon, 12 Oct 2009 15:10:00 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Morris <jmorris@namei.org>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Stephen D. Smalley" <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: mark a locally-only used function static
Message-ID: <20091012221000.GA31129@kroah.com>
References: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de>
 <20091011044221.GA8714@kroah.com>
 <4AD18EB4.7010909@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD18EB4.7010909@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 09:52:20AM +0200, Stefan Richter wrote:
> Greg KH wrote:
> > On Sun, Oct 11, 2009 at 03:02:46AM +0200, Stefan Richter wrote:
> >> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > 
> > Odd you didn't cc: the sysfs maintainer on this patch.  Any reason?
> > 
> > scripts/get_maintainer.pl is your friend...
> 
> Sheer laziness.  I trusted that those who introduced this function would
> handle it for me.

Cool, I'll be lazy and not apply it as it was not addressed to me :)

greg k-h
