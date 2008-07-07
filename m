Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYGGTh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYGGTh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYGGThs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:37:48 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:34755
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbYGGThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:37:48 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: azfs: initial submit of azfs, a non-buffered filesystem
Date: Mon, 7 Jul 2008 21:37:43 +0200
User-Agent: KMail/1.9.9
Cc: Maxim Shchetynin <maxim@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Arnd Bergmann <arnd@arndb.de>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com> <200807011659.33413.arnd@arndb.de> <20080707174230.63bc68cf@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <20080707174230.63bc68cf@mercedes-benz.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072137.45094.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7. July 2008, Maxim Shchetynin wrote:
> AZFS is a file system which keeps all files on memory mapped random
> access storage.
Hi Maxim, 
do you mean "memory backed" instead of "memory mapped"?

regards
Uli

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
