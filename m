Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbYBKQzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbYBKQzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbYBKQz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:55:28 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:18580 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbYBKQz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:55:26 -0500
Message-ID: <47B07DEB.3090803@siemens.com>
Date: Mon, 11 Feb 2008 17:55:07 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: cavokz@gmail.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v7
References: <20080210222025.GA6646@elte.hu> <20080211154133.GA3292@ska.dandreoli.com>
In-Reply-To: <20080211154133.GA3292@ska.dandreoli.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Domenico Andreoli wrote:
> On Sun, Feb 10, 2008 at 11:20:26PM +0100, Ingo Molnar wrote:
>> this is -v7 of the KGDB-light tree, which can be pulled from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git
> 
> my git hangs on this..

Just booting? Or using the debugger? If the former: does switching KGDB
off in the config solve it?

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
