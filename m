Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZHZICm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZHZICm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZHZICl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:02:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:34768 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750984AbZHZICj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:02:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/YZkoFyt3YiityCsWczQoP9ZYAZOtltvPcsg6Hig
	XUGaqvVH5BRiBK
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Mike Galbraith <efault@gmx.de>
To: raz ben yehuda <raziebe@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Chris Friesen <cfriesen@nortel.com>,
       Christoph Lameter <cl@linux-foundation.org>, riel@redhat.com,
       mingo@elte.hu, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
In-Reply-To: <1251282598.3514.20.camel@raz>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
	 <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>
	 <1251264700.7538.1178.camel@twins>  <1251282598.3514.20.camel@raz>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 10:02:35 +0200
Message-Id: <1251273755.16910.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 13:29 +0300, raz ben yehuda wrote:

> OFFSCHED is bad name to my project. My project is called SOS = Service
> Oriented System.
> SOS, has nothing to do with Real time.

??

The paper you pointed me at maintains it's very much about realtime.

<quote>
This paper argues that OFFSCHED fits to the niche of Multiprocessors
real time systems by partitioning a system to two; the operating system
and OFFSCHED. OFFSHCED is a hybrid system. It is hybrid because it is
both real time and still a regular Linux server. Real time is mainly
achieved by the NMI characteristic and the CPU isolation. It is a hybrid
system because OFFSCHED scheduler interacts with the operating system.
</quote>

	-Mike.

