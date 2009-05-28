Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZE1M3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZE1M3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZE1M3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:29:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22043 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbZE1M3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:29:04 -0400
Date: Thu, 28 May 2009 14:28:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       stable <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH-tip] x86: hwmon/k8temp.c Add support for 
 AMD 10H and 11H
Message-ID: <20090528142837.530ba070@hyperion.delvare>
In-Reply-To: <1243511849.3669.5.camel@localhost.localdomain>
References: <1242979484.8796.7.camel@localhost.localdomain>
	<4A165F67.3020005@assembler.cz>
	<1242981748.10642.3.camel@localhost.localdomain>
	<1242984648.16532.3.camel@localhost.localdomain>
	<4A182B61.5010503@assembler.cz>
	<1243339833.12303.2.camel@localhost.localdomain>
	<4A1C08C6.7060103@assembler.cz>
	<1243352672.31783.10.camel@localhost.localdomain>
	<1243511849.3669.5.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 17:27:29 +0530, Jaswinder Singh Rajput wrote:
> Hello Andrew, Greg and Ingo:
> 
> Do you think this patch should go to stable and latest git.

Definitely not to stable, it's not fixing any bug.

-- 
Jean Delvare
