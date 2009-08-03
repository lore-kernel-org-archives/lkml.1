Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZHCV3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZHCV3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZHCV3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:29:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44452 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbZHCV3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:29:11 -0400
Subject: Re: MAINTAINERS: standardize James Bottomley's name
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1249333863.5149.58.camel@Joe-Laptop.home>
References: <1249331570.5149.48.camel@Joe-Laptop.home>
	 <1249332233.3943.211.camel@mulgrave.site>
	 <1249333863.5149.58.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 21:29:09 +0000
Message-Id: <1249334949.3943.222.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 14:11 -0700, Joe Perches wrote:
> On Mon, 2009-08-03 at 20:43 +0000, James Bottomley wrote:
> > On Mon, 2009-08-03 at 13:32 -0700, Joe Perches wrote:
> > > His recent patches and sign-offs have not used "E.J."
> > > 
> > > This reduces the likelihood that get_maintainers.pl will
> > > list his address twice.
> > 
> > It is standard:  I like my initials; which, per RFC requires the quotes
> > because it's a mailing address.
> 
> Then change the other entry.
> 
> And if you really like your initials, you should probably change
> the email address format you're using right now and probably the
> mechanism you use to send your patches and acks as well.
> 
> Look at the name I'm replying to: (no quotes)
> 	"James Bottomley <James.Bottomley@HansenPartnership.com>"
> 
> Right now, if somebody uses get_maintainers.pl on a patch for a
> file in drivers/scsi, git will find your signoffs as
> 
> (no quotes)
> 	"James Bottomley <James.Bottomley@HansenPartnership.com>"
> 
> and the scripts/get_maintainers.pl will use MAINTAINERS entry of
> 
> (with quotes)
> 	"James E.J. Bottomley <James.Bottomley@HansenPartnership.com>"
> 
> You'll be cc'd twice and .mailmap doesn't have enough information
> to select your preferred email address.

Assuming people blindly use the scripts, rest assured that my email
system won't collapse under the weight of the extra cc's.

James


