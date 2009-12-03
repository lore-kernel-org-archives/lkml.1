Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZLCR0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZLCR0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZLCR0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:26:07 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55505 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbZLCR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:26:06 -0500
X-Sasl-enc: g+tgu8K2wv2JZT5MgAOWUI7lRw45lH95+lmx0nIcr1IL 1259861172
Date: Thu, 3 Dec 2009 15:26:09 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: convert to seq_file
Message-ID: <20091203172609.GA16463@khazad-dum.debian.net>
References: <20091125071642.GD3459@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125071642.GD3459@x200.malnet.ru>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey,  I like your patch, but it pretty much clashes with lots of stuff in
my patch queue.

I think the easiest way is for me to take in your patch, place it at the end
of the queue, and update it when I get to it.

I won't promise I will be able to merge it for 2.6.33, but I can promise I
will do it for 2.6.34.  Depends how fast I can get the higher priority stuff
out of the door.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
