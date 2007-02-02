Return-Path: <linux-kernel-owner+w=401wt.eu-S1945938AbXBBQEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945938AbXBBQEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945950AbXBBQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:04:50 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:63969 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945938AbXBBQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:04:49 -0500
Message-ID: <45C3611D.6070105@fr.ibm.com>
Date: Fri, 02 Feb 2007 17:04:45 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Starikovskiy, Alexey Y" <alexey.y.starikovskiy@intel.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Moore, Robert" <robert.moore@intel.com>,
       keith mannthey <kmannth@us.ibm.com>
Subject: Re: 2.6.20-rc6-mm3
References: <B41635854730A14CA71C92B36EC22AAC7CC863@mssmsx411>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC7CC863@mssmsx411>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Starikovskiy, Alexey Y wrote:
>> so it probably means that drivers/acpi/tables/tbxfroot.c is
>> obsolete ?
> Yes.
>>> Could you please try it?
>> sure, I'll cancel the current boot test in which I was using
>> acpi_find_root_pointer() in tbxfroot.c and restart one with your
>> new patch. I should have the result today.
> How long does it take to boot this thing?

well, not that long, but i don't have access directly to this 
machine, only through a test batch manager ... 

C.
