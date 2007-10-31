Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbXJaUY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbXJaUY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXJaUYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:24:52 -0400
Received: from tim.rpsys.net ([194.106.48.114]:37995 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbXJaUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:24:51 -0400
Subject: Re: [PATCH 3/3] leds-clevo-mail: driver for Clevo mail LED
From: Richard Purdie <rpurdie@rpsys.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
In-Reply-To: <472470DC.3080809@freemail.hu>
References: <4718FD04.3080602@freemail.hu>
	 <20071019133607.3419b00a.randy.dunlap@oracle.com>
	 <471B4BA5.30100@freemail.hu>  <471B4C46.9030502@freemail.hu>
	 <1193176104.5709.137.camel@localhost.localdomain>
	 <472470DC.3080809@freemail.hu>
Content-Type: text/plain; charset=utf-8
Date: Wed, 31 Oct 2007 15:14:21 +0100
Message-Id: <1193840061.12294.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-28 at 12:22 +0100, Németh Márton wrote:
> Richard Purdie wrote:
> > Hmm, there really is no way to just turn the LED on? :(
> 
> Unfortunately I do not have these optional modules so I never saw the LED
> just on without blinking. I don't know if there is any hardware limitation
> turning on the LED without the optional modules.

Ok, if we don't know how to do it or even if its possible, so be it. If
you ever do find out please do update the driver.

> I will send a new patch collection which addresses the other mentioned topics.

Thanks, I've applied the patches although I've rewritten the second one
to update the drivers with LED names that don't match the naming
convention. They'll appear in the led git tree and hence -mm.

Thanks,

Richard

