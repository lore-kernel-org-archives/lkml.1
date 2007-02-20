Return-Path: <linux-kernel-owner+w=401wt.eu-S1030448AbXBTVvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448AbXBTVvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030469AbXBTVvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:51:04 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:53668 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030448AbXBTVvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:51:03 -0500
Date: Tue, 20 Feb 2007 16:51:03 -0500
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070220215103.GB22464@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca> <45D9BDBF.8040405@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <m33b505zez.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m33b505zez.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 09:47:48PM +0100, Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
> > Yes, VIA Epia EN12000.
> > Interesting to check the riser card.
> 
> Unfortunately it turns out it's single slot only.

Via has a dual pci-ext card.  See EXT-PCI at
http://www.via.com.tw/en/products/mainboards/accessories.jsp

--
Len Sorensen
