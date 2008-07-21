Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYGUH7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYGUH7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbYGUH7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:59:38 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:43722 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302AbYGUH7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:59:37 -0400
Message-ID: <4884426B.80105@keyaccess.nl>
Date: Mon, 21 Jul 2008 10:01:47 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 0/4] Second batch of fastboot patches: get rid of the
 2 second rootfs delay
References: <20080720151436.26bdc717@infradead.org>
In-Reply-To: <20080720151436.26bdc717@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-07-08 00:14, Arjan van de Ven wrote:

> this second batch of fastboot patches gets rid of the delay you can get
> when you're not using an initrd; on my system this delay is a full 2
> seconds (which is longer than the whole kernel boot combined).
> 
> I've also stuck the patch series into a git tree
> 
> clone git://git.kernel.org/pub/scm/linux/git/arjan/linux-2.6-fastboot

Initialized empty Git repository in 
/home/rene/src/linux/linux-2.6-fastboot/.git/
fatal: The remote end hung up unexpectedly
fetch-pack from 
'git://git.kernel.org/pub/scm/linux/git/arjan/linux-2.6-fastboot' failed.

Rene.
