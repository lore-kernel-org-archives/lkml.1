Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbZE1ORx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbZE1ORx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbZE1ORn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:17:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:56000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbZE1ORm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:17:42 -0400
Subject: Re: [lm-sensors] [PATCH-tip] x86: hwmon/k8temp.c Add support for 
 AMD 10H and 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       stable <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <20090528142837.530ba070@hyperion.delvare>
References: <1242979484.8796.7.camel@localhost.localdomain>
	 <4A165F67.3020005@assembler.cz>
	 <1242981748.10642.3.camel@localhost.localdomain>
	 <1242984648.16532.3.camel@localhost.localdomain>
	 <4A182B61.5010503@assembler.cz>
	 <1243339833.12303.2.camel@localhost.localdomain>
	 <4A1C08C6.7060103@assembler.cz>
	 <1243352672.31783.10.camel@localhost.localdomain>
	 <1243511849.3669.5.camel@localhost.localdomain>
	 <20090528142837.530ba070@hyperion.delvare>
Content-Type: text/plain
Date: Thu, 28 May 2009 19:43:34 +0530
Message-Id: <1243520014.3143.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 14:28 +0200, Jean Delvare wrote:
> On Thu, 28 May 2009 17:27:29 +0530, Jaswinder Singh Rajput wrote:
> > Hello Andrew, Greg and Ingo:
> > 
> > Do you think this patch should go to stable and latest git.
> 
> Definitely not to stable, it's not fixing any bug.
> 

Ok, so you suggested this should go to latest git.

I proposed for stable because I was using AMD 11H from last 6 months and
I was missing temperature monitor badly because my earlier Laptop was
broken by overheating. So I thought if it goes to stable then users will
start getting benefit of it, but if you want that users should wait for
another 2 years. Then it is OK ;-)

Thanks,
--
JSR

