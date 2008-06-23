Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYFWI5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYFWI5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYFWI5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:57:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:35314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYFWI5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:57:03 -0400
Message-ID: <485F6540.6000907@kernel.org>
Date: Mon, 23 Jun 2008 17:56:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andreas Schwab <schwab@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       jgarzik@pobox.com, IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
References: <20080617093602.GA28140@elf.ucw.cz> <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz> <je63s0sfxv.fsf@sykes.suse.de> <20080623085338.GE1850@elf.ucw.cz>
In-Reply-To: <20080623085338.GE1850@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Mon, 23 Jun 2008 08:56:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2008-06-23 10:39:40, Andreas Schwab wrote:
>> Pavel Machek <pavel@suse.cz> writes:
>>
>>> +	   controller, the controller could hang. In other cases it
>>> +	   could return partial data returning in data
>>> +	   corruption. This problem has been seen in PPC systems and
>> s/returning/resulting/ ?
> 
> Fix thinko in sata_svw comment.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Please collapse into one patch.  Thanks.

-- 
tejun
