Return-Path: <linux-kernel-owner+w=401wt.eu-S1750717AbXIUJoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750717AbXIUJoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXIUJoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:44:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:59432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbXIUJoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:44:37 -0400
Date: Fri, 21 Sep 2007 11:44:22 +0200
To: "Gregory 'GaLi' Cavelier" <gali@cleia.org>
Cc: kkeil@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ISDN: Change pci_find_device() calls to pci_get_device()
Message-ID: <20070921094422.GA10599@ahaupt-debian-vm.localdomain>
References: <20070921105508.d1a6a369.gali@cleia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921105508.d1a6a369.gali@cleia.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andre Haupt <andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX191SwthZMY1S9AdPZh3Fp6OwWu8aseJq3PTbJ6
 TJEF9GG3UvQbSqL62f2CUNHO1RgFEpT+khW3dZB8XD45OxgArL
 GcDquzKdwi8kQHxfl9D6Lf4HMb6xgA0+udMfMPcyM4=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:55:08AM +0200, Gregory 'GaLi' Cavelier wrote:
> 
> The following patch removes the obsolete pci_find_device() calls and replaces them with pci_get_device() for all ISDN drivers.
> 
No, it does not. It replaces the correct pci_get_device() calls in the
isdn tree with the obsolete pci_find_device(). ;-)

regards,

Andre
