Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbYESOmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbYESOmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbYESOmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:42:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbYESOmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:42:08 -0400
Message-ID: <483190E3.9040306@redhat.com>
Date: Mon, 19 May 2008 10:38:27 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, rostedt@goodmis.org
Subject: Re: 2.6.26-rc2-mm1 - machine stuck while booting up with CONFIG_FTRACE_STARTUP_TEST
 enabled
References: <20080514010129.4f672378.akpm@linux-foundation.org> <4831658F.2020306@linux.vnet.ibm.com> <48317A72.701@redhat.com> <483189C2.7050207@linux.vnet.ibm.com>
In-Reply-To: <483189C2.7050207@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:

> Hi Steven,
> 
> Passing nmi_watchdog=1 did not help in getting any extra information, over the previous
> console log. The boot up message is stuck exactly at the same place.
> 

Thanks for trying.

Can you send your config privately to my goodmis account.

  rostedt@goodmis.org

Thanks,

-- Steve
