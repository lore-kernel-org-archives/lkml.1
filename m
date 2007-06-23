Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbXFWOfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbXFWOfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbXFWOez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:34:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbXFWOey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:34:54 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Date: Sat, 23 Jun 2007 16:34:42 +0200
User-Agent: KMail/1.9.6
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231517.28085.ak@suse.de> <20070623153239.78ee86fe@the-village.bc.nu>
In-Reply-To: <20070623153239.78ee86fe@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231634.42907.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007 16:32:39 Alan Cox wrote:
 
> Having the scripts work with other shells is very helpful for porting,
> cross building and the like.

Well then for the majority of cross compile users you should consequently write 
them in Windows batch language.

> Also on Linux /bin/sh is not 
> neccessarily /bin/bash.

If it's not I think these few distributions give Linux a bad name 
because they introduce quite unnecessary incompatibilities.
Hopefully they are not widely used.

-Andi
