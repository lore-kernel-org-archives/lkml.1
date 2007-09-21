Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbXIUJ46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbXIUJ46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXIUJ4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:56:50 -0400
Received: from hq.materiel.net ([195.167.193.66]:48679 "EHLO hq.materiel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbXIUJ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:56:50 -0400
Date: Fri, 21 Sep 2007 11:56:48 +0200
From: "Gregory 'GaLi' Cavelier" <gali@cleia.org>
To: Andre Haupt <andre@bitwigglers.org>
Cc: kkeil@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ISDN: Change pci_find_device() calls to
 pci_get_device()
Message-Id: <20070921115648.398391b3.gali@cleia.org>
In-Reply-To: <20070921094422.GA10599@ahaupt-debian-vm.localdomain>
References: <20070921105508.d1a6a369.gali@cleia.org>
	<20070921094422.GA10599@ahaupt-debian-vm.localdomain>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Wow, how stupid am i ?!?

Did 'git-diff gali master' instead of 'git-diff master gali'

Anyway, going out slapping myself, sorry for the noise...

On Fri, 21 Sep 2007 11:44:22 +0200
Andre Haupt <andre@bitwigglers.org> wrote:

> On Fri, Sep 21, 2007 at 10:55:08AM +0200, Gregory 'GaLi' Cavelier wrote:
> > 
> > The following patch removes the obsolete pci_find_device() calls and replaces them with pci_get_device() for all ISDN drivers.
> > 
> No, it does not. It replaces the correct pci_get_device() calls in the
> isdn tree with the obsolete pci_find_device(). ;-)
> 
> regards,
> 
> Andre

-- 
Gregory 'GaLi' Cavelier
                        _
 ASCII ribbon campaign ( )
 - against HTML email   X
              & vCards / \
