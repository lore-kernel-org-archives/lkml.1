Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYDWU50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYDWU50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYDWU5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:57:18 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:47803 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbYDWU5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:57:17 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: monstr@seznam.cz
Subject: Re: Microblaze Linux release
Date: Wed, 23 Apr 2008 22:57:02 +0200
User-Agent: KMail/1.9.9
Cc: Arnd Bergmann <arnd@arndb.de>, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
References: <48020A21.4000404@seznam.cz> <200804161733.04714.arnd@arndb.de> <480FA235.8000203@seznam.cz>
In-Reply-To: <480FA235.8000203@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804232257.04060.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 5E2BD3ED2DD.BCB3B
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal

Le mercredi 23 avril 2008, Michal Simek a écrit :
> Hi all,
>
> I update Microblaze kernel to latest Linus tree. I fixed some problems
> which come with it.

While reading the previous discussion, I wondered that keeping PCI would be a 
good idea. I am personnaly using it for a custom design and would be glad 
being able to continue using it.

If this represents too much work for you, we can probably add it later.

Great work !
-- 
