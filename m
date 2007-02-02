Return-Path: <linux-kernel-owner+w=401wt.eu-S1945907AbXBBOrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945907AbXBBOrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945908AbXBBOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:47:40 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:44564 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945907AbXBBOrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:47:39 -0500
Message-ID: <45C34F08.90307@fr.ibm.com>
Date: Fri, 02 Feb 2007 15:47:36 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Starikovskiy, Alexey Y" <alexey.y.starikovskiy@intel.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Moore, Robert" <robert.moore@intel.com>,
       keith mannthey <kmannth@us.ibm.com>
Subject: Re: 2.6.20-rc6-mm3
References: <B41635854730A14CA71C92B36EC22AAC7CC853@mssmsx411>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC7CC853@mssmsx411>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

Starikovskiy, Alexey Y wrote:
> Hi,
> I updated patch to use acpi_find_rsdp(), as all other code does.

so it probably means that drivers/acpi/tables/tbxfroot.c is 
obsolete ?

> Could you please try it?

sure, I'll cancel the current boot test in which I was using 
acpi_find_root_pointer() in tbxfroot.c and restart one with your
new patch. I should have the result today.
 
> Thanks,
> 	Alex.


Thanks !

C.
