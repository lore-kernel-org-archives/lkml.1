Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZAMQqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZAMQqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZAMQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:45:44 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47910 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZAMQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:45:43 -0500
Date: Tue, 13 Jan 2009 11:34:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-01-12
Message-ID: <20090113163455.GC3623@tuxdriver.com>
References: <20090112201302.GB3786@tuxdriver.com> <20090112.212345.259792227.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112.212345.259792227.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 09:23:45PM -0800, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 12 Jan 2009 15:13:02 -0500
> 
> > Please let me know if there are problems!
> 
> There's something funny in this tree.   In changeset
> 19f0a391bf9d88307e52557ff3125b24e2519bd4 there is
> a removal of arch/arm/mach-integrator/clock.h
> 
> I think when you installed that commit something
> automatically deleted zero length files it found,
> but that's just a guess.
> 
> Please fix this up so I can pull from you.
> 
> Otherwise all of those changes looked fine.
 
Hmmm...dirty tree I suppose.  Sorry about that!  I should have noticed
that in the changelog.

I'll post a new pull request immediately.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
