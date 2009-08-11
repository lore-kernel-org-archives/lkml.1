Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZHKPPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZHKPPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZHKPPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:15:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbZHKPPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:15:05 -0400
Message-ID: <4A818A39.3000201@redhat.com>
Date: Tue, 11 Aug 2009 11:11:53 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>, andi.kleen@intel.com,
       Pavel Emelianov <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale better (v4)
References: <20090811144405.GW7176@balbir.in.ibm.com> <4A81863A.2050504@redhat.com> <20090811150057.GY7176@balbir.in.ibm.com>
In-Reply-To: <20090811150057.GY7176@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>     
>
> Without the patch and RESOURCE_COUNTERS do you see a big overhead. I'd
> assume so, I am seeing it on my 24 way box that I have access to.
>   

I see a *huge* overhead:

real 27m8.988s
user 87m24.916s
sys 382m6.037s

P.
