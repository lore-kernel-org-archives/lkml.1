Return-Path: <linux-kernel-owner+w=401wt.eu-S1422963AbXBAX63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422963AbXBAX63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422965AbXBAX63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:58:29 -0500
Received: from neopsis.com ([213.239.204.14]:51393 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422963AbXBAX63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:58:29 -0500
Message-ID: <45C2832F.10603@dbservice.com>
Date: Fri, 02 Feb 2007 01:17:51 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0b1 (X11/20061212)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr> <45C2670F.5000003@jonmasters.org>
In-Reply-To: <45C2670F.5000003@jonmasters.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.37,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> need a technological mechanism here to enforce the obvious. To me, it
> just seems totally obvious (any legal comment?) that early C string
> termination is undermining the intent of the MODULE_LICENSE tag.
> 

I completely agree with that. It's like I sign a contract and the other
party later makes claims and says: Well, you sure you read the whole
contract? 'Coz in the part that was written with special ink, only
visible under special light, it clearly states that ...

Can't you put this somewhere into the documentation: it's our kernel,
play by our rules, and our rules are, the license is what is visible in
'printf(license)'?

tom
