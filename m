Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYIDMcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYIDMcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYIDMbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:31:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYIDMbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:31:53 -0400
Message-ID: <48BFD48B.7050202@redhat.com>
Date: Thu, 04 Sep 2008 14:28:59 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 00/42] 2.6.26-stable review
References: <20080903172447.GA7731@suse.de> <20080904023905.GA1071@khazad-dum.debian.net> <48BFD2D7.20209@linux.intel.com>
In-Reply-To: <48BFD2D7.20209@linux.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andi Kleen wrote:
> Henrique de Moraes Holschuh wrote:
>> What about this one:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
>>
>> "ACPI: Fix thermal shutdowns" ?
>>
>> It should have been submitted to stable@k.o well before 2.6.26.3,
> 
> Nope because the bug it fixed was only introduced for 2.6.27-rc1.

No Andi, the bug _is_ in 2.6.26 tree!

Introduced in 2.6.26.2.
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=commit;h=04f496871e8af87a1e40c504371a206fd7389193

Milan
--
mbroz@redhat.com

