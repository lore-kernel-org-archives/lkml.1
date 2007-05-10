Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXEJSHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXEJSHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbXEJSHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:07:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54944 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXEJSHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:07:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46435EF5.5010306@s5r6.in-berlin.de>
Date: Thu, 10 May 2007 20:05:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net,
       Kristian H?gsberg <krh@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Olaf Hering <olh@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Bill Fink <billfink@mindspring.com>
Subject: Re: [git pull] New firewire stack (updated)
References: <4637A29F.6070302@redhat.com> <tkrat.b635518ff171071d@s5r6.in-berlin.de> <20070510173850.GA31826@infradead.org>
In-Reply-To: <20070510173850.GA31826@infradead.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> ACK from me.  I still have some comments but none of them is a merge
> blocker.

I put one small fix that Kristian sent on hold (const char * vs char *
for shostt->proc_name) to let a related patch go to scsi-misc first.
So this open item is my fault, not his. :-)
-- 
Stefan Richter
-=====-=-=== -=-= -=-=-
http://arcgraph.de/sr/
