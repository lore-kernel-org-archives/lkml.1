Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZAKVPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZAKVPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZAKVOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:14:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:13209 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753081AbZAKVOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:14:44 -0500
Message-ID: <496A613F.5090901@ru.mvista.com>
Date: Mon, 12 Jan 2009 00:14:39 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev list <Linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 2/9] sl82c105: remove dead code
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain> <20090106183526.21193.24866.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183526.21193.24866.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> CONFIG_LOPEC and CONFIG_SANDPOINT config options are gone.
>   

  So these are gone with arch/ppc/?
  That's a pity -- MV has spent a lot of efforts on porting the latter 
to arch/powerpc/ but somehow it haven't got merged upstream. My patches 
ot this driver were actually due to it being used on Sandpoint. :-)

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


