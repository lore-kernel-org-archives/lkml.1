Return-Path: <linux-kernel-owner+w=401wt.eu-S1945924AbXBPJ6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945924AbXBPJ6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945925AbXBPJ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:58:30 -0500
Received: from ns.firmix.at ([62.141.48.66]:42537 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945924AbXBPJ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:58:29 -0500
Subject: Re: GPL vs non-GPL device drivers
From: Bernd Petrovitsch <bernd@firmix.at>
To: Scott Preece <sepreece@gmail.com>
Cc: Stuart MacDonald <stuartm@connecttech.com>, v j <vj.linux@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <7b69d1470702151636y243919c0n5307eaf7d20499c2@mail.gmail.com>
References: <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
	 <000001c7511d$829e91c0$294b82ce@stuartm>
	 <7b69d1470702151636y243919c0n5307eaf7d20499c2@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix software GmbH
Date: Fri, 16 Feb 2007 10:58:13 +0100
Message-Id: <1171619893.23981.14.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.417 required=5
X-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 18:36 -0600, Scott Preece wrote:
[...]
> Note that it is possible that what vj said is strictly true. IF the
> product they ship is non-modifiable, then it's hard to argue that
> anyone else could maintain it. And if the drivers are for devices

The GPL has no special handling for that case.

> proprietary to their hardware, then they have no real value to anyone
> else. And the drivers MIGHT contain information useful to their actual
> competitors. I have no knowledge as to whether those conditions

And that may a (BTW invalid) reason for lots of companies but you
probably won't find an exception in the GPLv2 for this.
And if you infringe on others' patents, you should probably look
elsewhere for a solution of that problem.

> actually apply.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

