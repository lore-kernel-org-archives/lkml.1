Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0BVQ61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:58:27 -0500
Received: from mga05.intel.com ([192.55.52.89]:61677 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752344Ab0BVQ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:58:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,519,1262592000"; 
   d="scan'208";a="774840583"
Message-ID: <4B82B7B0.7040203@linux.intel.com>
Date: Mon, 22 Feb 2010 08:58:24 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Cong Wang <amwang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=C3?= =?ISO-8859-15?Q?=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Arnd Bergmann <arnd@arndb.de>, Hui Zhu <teawater@gmail.com>,
       =?ISO-8859-15?Q?Ozan_=C3aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: improve checkstack
References: <20100219175217.385580142@vyatta.com>	<20100219175429.611463369@vyatta.com>	<4B7F5128.70501@redhat.com>	<20100219222554.17d4bae6@nehalam>	<4B7F90AA.8050306@redhat.com> <20100222084339.1367cfe6@nehalam>
In-Reply-To: <20100222084339.1367cfe6@nehalam>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2010 8:43, Stephen Hemminger wrote:


btw as a general comment on these guys

"make it more perl-ish" is not a good feature for me.

"make it more readable" would be.

these guys are not performance sensitive, lets make them as readable as possible, and not line noise.

