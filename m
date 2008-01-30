Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbYA3SyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbYA3SyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYA3SyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:54:13 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33014 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYA3SyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:54:12 -0500
Date: Wed, 30 Jan 2008 20:54:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Giridhar Pemmasani <pgiri@yahoo.com>, Pavel Roskin <proski@gnu.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080130185446.GF29368@does.not.exist>
References: <20080129225701.GS8767@does.not.exist> <754585.89171.qm@web32403.mail.mud.yahoo.com> <20080130175447.GB29368@does.not.exist> <47A0C138.2070807@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47A0C138.2070807@nortel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 12:26:00PM -0600, Chris Friesen wrote:
> Adrian Bunk wrote:
>
>> IANAL, but I have serious doubts whether putting some glue layer 
>> between the GPL'ed code and the code with a not GPL compatible licence 
>> is really a legally effictive way of circumventing the GPL.
>
> It may depend on the details of the "code with a not GPL compatible  
> licence".
>
> It's pretty hard to argue that a binary driver written for another OS is  
> a derivative work of the linux kernel.

Read the paragraph starting with "These requirements apply to the 
modified work as a whole." of the GPLv2.

IANAL, and I would therefore ask a lawyer whether, and if yes under 
which circumstances, shipping a binary driver written for another OS
dynamically linked into the Linux kernel would not be a criminal offense.

> Chris

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

