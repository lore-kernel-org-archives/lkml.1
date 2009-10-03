Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZJCOjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZJCOjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZJCOjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:39:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54587 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbZJCOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:39:22 -0400
X-Sasl-enc: MrcRNCjKH0QjXWwERknhEEiP8Ib982Q6WtcU8i1uXL4+ 1254580765
Date: Sat, 3 Oct 2009 11:39:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/30] 2.6.30.9-stable review
Message-ID: <20091003143921.GC31552@khazad-dum.debian.net>
References: <20091001233504.GA17709@kroah.com>
 <20091002024317.GA2045@khazad-dum.debian.net>
 <20091002142021.GB20816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002142021.GB20816@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Oct 2009, Greg KH wrote:
> On Thu, Oct 01, 2009 at 11:43:17PM -0300, Henrique de Moraes Holschuh wrote:
> > Greg, I sent a few days ago to you guys a patch for thinkpad-acpi to unbreak
> > a _very_ annoying brightness control bug on 2.6.30 on many IBM thinkpads.
> > 
> > Could you please include it?
> > 
> > http://patchwork.kernel.org/patch/50201/
> 
> Ick, you are right, I missed that one somehow, it's still in my
> "todo-stable" mbox as well.  My fault, I'll go queue it up and release a
> -rc2 for .30-stable.

Thank you!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
