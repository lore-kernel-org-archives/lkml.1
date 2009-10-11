Return-Path: <linux-kernel-owner+w=401wt.eu-S1750965AbZJKEol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965AbZJKEol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 00:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZJKEol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 00:44:41 -0400
Received: from kroah.org ([198.145.64.141]:60761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbZJKEol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 00:44:41 -0400
Date: Sat, 10 Oct 2009 21:42:21 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Morris <jmorris@namei.org>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Stephen D. Smalley" <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: mark a locally-only used function static
Message-ID: <20091011044221.GA8714@kroah.com>
References: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 03:02:46AM +0200, Stefan Richter wrote:
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Odd you didn't cc: the sysfs maintainer on this patch.  Any reason?

scripts/get_maintainer.pl is your friend...

thanks,

greg k-h
