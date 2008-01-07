Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYAGWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYAGWin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYAGWid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:38:33 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:49947 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYAGWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:38:32 -0500
Message-ID: <4782AA0B.9070506@fel.cvut.cz>
Date: Tue, 08 Jan 2008 08:39:07 +1000
From: Michal Simek <simekm2@fel.cvut.cz>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Michal Simek <simekm2@fel.cvut.cz>, linux-kernel@vger.kernel.org
Subject: Re: New linux arch
References: <47820D24.3060800@fel.cvut.cz> <1199743233.6734.16.camel@pasglop>
In-Reply-To: <1199743233.6734.16.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

>> I redesigned all files for microblaze cpu (xilinx fpga).
>> All code is FDT compatible.
> 
> For those who don't know, FDT is the flattened device-tree format used
> nowadays on PowerPC, based on the open firmware device-tree.
> 
> I'm really happy to see that being picked up by another architecture,
> that's great !

:-) Plus for embedded Xilinx FPGA cpu - PPC405 and Microblaze you can 
generate DTS file from EDK project.

Michal Simek
