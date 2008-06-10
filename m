Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYFJLrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYFJLrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 07:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYFJLre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 07:47:34 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:38367
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYFJLrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 07:47:33 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: i2c@lm-sensors.org
Subject: Re: [i2c] Frame buffers and early i2c
Date: Tue, 10 Jun 2008 13:47:30 +0200
User-Agent: KMail/1.9.9
Cc: Ben Dooks <ben@fluff.org>, David Brownell <david-b@pacbell.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com
References: <200806091647.42757.u.luckas@road.de> <200806101131.19763.u.luckas@road.de> <20080610100249.GA30539@fluff.org.uk>
In-Reply-To: <20080610100249.GA30539@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101347.31003.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday, 10. June 2008, Ben Dooks wrote:
> BTW, if people do have these sort of dependencies, then modules
> are another way of sorting out the load order, unless you have
> the module autoload enabled.
>
True. But my original post stated:
> In order to use the frame buffer console I have i2c and pxafb compiled in
This is one example where waiting for user space to be up and running is not 
an option.

regards,
Uli

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
