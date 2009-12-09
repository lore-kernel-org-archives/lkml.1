Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZLIVrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZLIVrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZLIVrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:47:12 -0500
Received: from isilmar.linta.de ([213.133.102.198]:58514 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754863AbZLIVrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:47:10 -0500
Date: Wed, 9 Dec 2009 22:37:36 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, blofeldus@yahoo.com,
       Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] cardbus: Add a fixup hook and fix powerpc
Message-ID: <20091209213736.GA25968@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, blofeldus@yahoo.com,
	Olof Johansson <olof@lixom.net>
References: <1260341533.16132.20.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260341533.16132.20.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Benjamin,

On Wed, Dec 09, 2009 at 05:52:13PM +1100, Benjamin Herrenschmidt wrote:
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net> (for PCMCIA)

> Note: In the long run we might want to streamline the hooks for fixing
> up new devices vs. new busses and make some stuff common between cardbus
> and PCI hotplug which is actually a mess.

... though I'd prefer such a generic approach.

Best,
	Dominik
