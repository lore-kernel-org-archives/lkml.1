Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZLDKmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZLDKmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:42:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZLDKmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:42:00 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54846 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbZLDKl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:41:59 -0500
Date: Fri, 4 Dec 2009 11:42:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Colin Leroy <colin@colino.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
Message-ID: <20091204114203.4f5e4188@hyperion.delvare>
In-Reply-To: <20091204112000.0cf0b0e7@paperstreet.colino.net>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	<1259894454.2076.1246.camel@pasglop>
	<20091204103434.0a754925@hyperion.delvare>
	<20091204112000.0cf0b0e7@paperstreet.colino.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On Fri, 4 Dec 2009 11:20:00 +0100, Colin Leroy wrote:
> On Fri, 4 Dec 2009 10:34:34 +0100, Jean Delvare wrote:
> > $ scripts/get_maintainer.pl --file drivers/macintosh/therm_adt746x.c 
> > Colin Leroy <colin@colino.net>
> > Grant Likely <grant.likely@secretlab.ca>
> > linux-kernel@vger.kernel.org
> > devicetree-discuss@lists.ozlabs.org
> > 
> > This lists Colin Leroy, who apparently doesn't exactly care about the
> > driver, but not linuxppc-dev@*ozlabs.org where you say patches should
> > be sent.
> 
> I'm sorry, I thought I wasn't listed as a maintainer anymore for
> this... I don't have the hardware anymore.

Care to submit a patch removing the "ADT746X FAN DRIVER" entry from
MAINTAINERS then? Unless someone volunteers quickly to take over.

-- 
Jean Delvare
