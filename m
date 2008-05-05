Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYEEP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYEEP5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYEEP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:57:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18563 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYEEP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:57:27 -0400
Date: Mon, 5 May 2008 08:56:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Patches for piping to core pattern ?
Message-Id: <20080505085609.32482c03.randy.dunlap@oracle.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA104@xmb-sjc-214.amer.cisco.com>
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA104@xmb-sjc-214.amer.cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 19:24:59 -0700 Ravinandan Arakali (rarakali) wrote:

> Hi,
> I am trying to port the "piping cores to an executable" to
> our kernel (2.6.10 based). I took Andi Kleen's patch (3/3)
> available at http://lwn.net/Articles/195310/ and some of
> the supporting functions from 2.6.19. But it's not working
> for me.
> 
> Andi's patch mentions "Using the infrastructure created in 
> previous patches implement support to pipe core dumps into 
> programs."
> 
> Can somebody point me to these previous patches ?

I don't know if these patches 1/3 and 2/3 represent the complete
infrastructure that Andi referred to, but you can find them here:

http://www.uwsg.indiana.edu/hypermail/linux/kernel/0608.1/2339.html
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0608.1/2340.html


---
~Randy
