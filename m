Return-Path: <linux-kernel-owner+w=401wt.eu-S1750725AbXBFGij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750725AbXBFGij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 01:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXBFGij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 01:38:39 -0500
Received: from terminus.zytor.com ([192.83.249.54]:37257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXBFGij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 01:38:39 -0500
Message-ID: <45C82266.3010007@zytor.com>
Date: Mon, 05 Feb 2007 22:38:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Etienne Lorrain <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Compressed ia32 ELF file generation for loading by Gujin
 1/3
References: <522909.27613.qm@web26909.mail.ukl.yahoo.com> <45C7CDD7.20806@zytor.com> <20070206052514.GA15613@in.ibm.com> <45C81D5B.3050408@zytor.com> <20070206063320.GA26462@in.ibm.com>
In-Reply-To: <20070206063320.GA26462@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> 
> That time, grub was working fine but lilo had broken on one of Andrew's
> machine. I could not reproduce the problem on my setup and had no clue what
> was the issue. Hence got rid of ELF header from bzImage which was non-essential
> stuff for relocatable kernel. But that issue should be fixable.
> 

Either way, though, putting Gujin-specific code in the main kernel 
output is a pretty dull thud.

	-hpa
