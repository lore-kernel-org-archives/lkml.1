Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYHZPtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYHZPtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 11:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYHZPtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 11:49:08 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:50782 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754322AbYHZPtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 11:49:06 -0400
Date: Tue, 26 Aug 2008 19:49:04 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Patches to support QE USB Host Controller
Message-ID: <20080826154904.GA26294@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <20080808232635.GB5352@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080808232635.GB5352@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 04:26:35PM -0700, Greg KH wrote:
> On Fri, Aug 08, 2008 at 08:17:17PM +0400, Anton Vorontsov wrote:
> > Hi all,
> > 
> > Most patches that were needed to support QE USB Host were merged during
> > 2.6.27 merge window, and only three more patches left over. Here they
> > are.
> > 
> > David, could you bear with gpio_to_chip() exported function, just as
> > a stopgap for a proper api?
> 
> I'll hold off on the 3rd patch until david takes the first two.

David, are there any issues with the first patch in the series?

It would be great if you'll ack the first patch, so that I'll
respin the whole patchset with some minor fixes in the 3rd patch.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
