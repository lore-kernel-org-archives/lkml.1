Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYJ3MMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYJ3MMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYJ3MMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:12:40 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:52829 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYJ3MMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:12:40 -0400
Date: Thu, 30 Oct 2008 13:12:35 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [PATCH] [CRIS] Move header files from include to
	arch/cris/include.
Message-ID: <20081030121235.GS4608@axis.com>
References: <20081021164211.GG24715@axis.com> <20081029173420.GM4608@axis.com> <20081029185313.GA22105@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029185313.GA22105@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 07:53:13PM +0100, Sam Ravnborg wrote:
> Hi Jesper.

Hi Sam,

> I have looked at the diffstat and the patches and this is a
> great improvement in readability of the cris stuff.
> 
> It would be good to get this in mainline as fast as possible.
> Can I ask you to prepare to git trees to pull from and ask
> Linus to pull it.
> First tree should be the header move only and if you can
> convince him it would be great to take the next two patches
> so add them to another tree.
> 
> You can add an:
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> on all three patches.

Thanks, good to hear. My original plan was to push all three for
2.6.28, but I will see if Linus accepts the changes for 2.6.27.

I would also be happy to see it go in as soon as possible.

>         Sam

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
