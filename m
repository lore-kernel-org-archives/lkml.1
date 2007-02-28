Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbXB1QVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbXB1QVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXB1QVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:21:16 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:58306 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXB1QVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:21:16 -0500
Message-ID: <45E5ABE7.5030900@freescale.com>
Date: Wed, 28 Feb 2007 10:20:55 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com> <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net> <45E593C2.6020004@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D8FD@dmoexc01.emea.cpqcorp.net> <0DA3FFD2-CFB8-44FB-872B-00D85B11213B@kernel.crashing.org>
In-Reply-To: <0DA3FFD2-CFB8-44FB-872B-00D85B11213B@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:

>> Its your choice if you want to limit it to 4 or have it moved into a
>> different minor range. I can live with both.
> 
> I'd rather we support 8 now.

Ok, a different minor range it is, then.  192-199?

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
