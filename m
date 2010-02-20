Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0BTDKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 22:10:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab0BTDKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 22:10:39 -0500
Message-ID: <4B7F534E.7040108@redhat.com>
Date: Sat, 20 Feb 2010 11:13:18 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Hui Zhu <teawater@gmail.com>,
       =?ISO-8859-1?Q?Ozan_=C3aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] namespace: perlcritic warnings
References: <20100219175217.385580142@vyatta.com> <20100219175429.826376846@vyatta.com>
In-Reply-To: <20100219175429.826376846@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You do more than what you said, e.g. you replaced a return in a
subroutine with die() which I think is not correct.

Please describe every of your changes.

Thanks.
