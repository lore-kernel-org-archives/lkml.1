Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbXEMUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbXEMUK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbXEMUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:10:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38432 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbXEMUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:10:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464770A0.4070809@s5r6.in-berlin.de>
Date: Sun, 13 May 2007 22:10:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: undeprecate raw driver.
References: <E1HnHxK-0004CI-00@calista.eckenfels.net> <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Sun, 13 May 2007, Bernd Eckenfels wrote:
> 
>> In article <Pine.LNX.4.64.0705131239200.942@localhost.localdomain> you wrote:
>>> in short, do *not* remove its "deprecated" status.  rather, remove its
>>> "obsolete" status and *make* it deprecated.
>> it is deprecated and obsolete.
> 
> no, it's not.  and, trust me, no one on this list wants me to have to
> explain all that again.  :-)

So why don't we simply say:

  - "Users of feature A are urged to migrate to alternative B."
  - "Feature C will be removed in February 2038."

Everybody understands the meaning of /that/.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
