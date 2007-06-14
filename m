Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbXFNFRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbXFNFRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 01:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXFNFQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 01:16:53 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:41935 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXFNFQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 01:16:52 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: DervishD <lkml@dervishd.net>
Subject: Re: ext2 on flash memory
Date: Thu, 14 Jun 2007 07:16:48 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20070611173611.GA2433@DervishD> <200706131516.41142.philipp.marek@bmlv.gv.at> <20070613230205.GA4815@DervishD>
In-Reply-To: <20070613230205.GA4815@DervishD>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140716.49087.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 14. Juni 2007, DervishD wrote:
>     Your message is very peculiar... because I already have a similar
> thing working on my system ;))) I tried FSVS and I didn't like it fully
> (don't ask me why, I don't even remember, that was a time ago), so I
> wrote my own system.
Well, if you ever remember (or do a new try), please tell me (or the mailing 
lists) your suggestions/ideas.


>     Instead of a complex solution, I opted for a simple (but ad-hoc)
> solution, writing a pre-commit-hook in Perl and a couple of files to
> store the metadata. Very simple but I have all my system configuration
> files (and other files that I want to have versioned) under SVN.
But you'd still need to manually restore the permissions, don't you?
And I think you don't take devices ...
BTW, "fsvs status" is much faster than "svn status" ... sometimes faster than 
find (on cold caches).

>     Thanks for your suggestion anyway, because I think that the concept
> (having versioned system files) is interesting and very useful :))
I think so too.


Thank you for your answer!


Regards,

Phil
