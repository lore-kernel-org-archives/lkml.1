Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZKKHv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZKKHv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZKKHv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:51:26 -0500
Received: from walscop001.walsimou.com ([82.228.201.70]:34621 "EHLO
	bekkor.walsimou.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbZKKHvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:51:25 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2009 02:51:25 EST
Message-ID: <4AFA6B7F.10404@walsimou.com>
Date: Wed, 11 Nov 2009 08:45:03 +0100
From: Gaye Abdoulaye Walsimou <walsimou@walsimou.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: myuboot@fastmail.fm
CC: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Subject: Re: Kernel panic - not syncing: Attempted to kill init!
References: <1255735395.30097.1340523469@webmail.messagingengine.com> <4AD906D8.3020404@caviumnetworks.com> <1257898975.30125.1344591929@webmail.messagingengine.com>
In-Reply-To: <1257898975.30125.1344591929@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

myuboot@fastmail.fm wrote:
> Hi, 
>
> I got the following error trying to bring up the /sbin/init with Kernel
> 2.6.31 using cramfs filesystem on a MIPS 32 board:
>   

Just to be sure does:
$file vmlinux
$file busybox
give the same result?

Regards
