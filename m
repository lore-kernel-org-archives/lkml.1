Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbXILWgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbXILWgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbXILWf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:35:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58077 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbXILWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:35:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46E869A2.4050500@s5r6.in-berlin.de>
Date: Thu, 13 Sep 2007 00:35:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, Jeff Garzik <jgarzik@pobox.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <46E6EE96.9060309@nortel.com> <46E6F2A8.2020104@pobox.com> <46E75C6A.3000705@nortel.com> <Pine.LNX.4.64.0709122007530.22467@fbirervta.pbzchgretzou.qr> <46E82D44.5030100@nortel.com>
In-Reply-To: <46E82D44.5030100@nortel.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Sep 11 2007 21:26, Chris Friesen wrote:
>>> Thunderbird, at least, will automatically inline a single text/plain
>>> attachment when replying. (At least with my current settings, it does.)

I dont know about Thunderbird, but Seamonkey apparently only includes
text/plain attachments in the reply quote if they feature
''Content-Disposition: inline''.  It does not include attachments with
''Content-Disposition: attachment; filename="abc123.patch"'' even if
they are text/plain.
-- 
Stefan Richter
-=====-=-=== =--= -==-=
http://arcgraph.de/sr/
