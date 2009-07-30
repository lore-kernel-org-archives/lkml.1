Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbZG3RJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbZG3RJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZG3RJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:09:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:57040 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751370AbZG3RJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:09:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+OmG1oLRaOUHpq5lsLUCrQAGYVq+MdT7ODnIbhGk
	3Ze/uVT4zQCbN+
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Mike Galbraith <efault@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Luis Correia <luis.f.correia@gmail.com>, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200907301852.28172.IvDoorn@gmail.com>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
	 <200907301517.57811.bzolnier@gmail.com>
	 <200907301852.28172.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 19:09:40 +0200
Message-Id: <1248973780.7091.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 18:52 +0200, Ivo van Doorn wrote:
> I planned, and actually did write, a lengthy reply for this thread, when I completed the reply
> I reconsidred and opted for this shorter reply. Every 2 or 3 months this discussion is started
> again and I am f***ing tired of it, so excuse me but I am not going to throw myself into
> this completely pointless discussion
> 
> What you are suggesting in your mail is something the rt2x00 project did for 5 years, we stopped
> with that 4 months ago because it wasn't working out. Apparently you have more experience in this
> matter so I hope you will find a way to make that solution work out.
> 
> If you want to maintain the legacy drivers then do it, start a new project and start maintaining
> the code. I can forward you all the users with complains about the "good enough" drivers. It is
> good to know that you apparently have the resources to maintain the old drivers. 
> Most people who are helping with the rt2800pci/usb drivers lack the required time to boost the driver
> into such a state it can be widely adopted. But every time it amazes me that the people who want
> to develop and have the time to do it, all want to jump on the old Ralink code... Apparently there
> is some appeal to maintaining crap rather then helping to ship out proper drivers to the users.
> 
> But I'll shut up now, as I said this discussion is held every few months, so perhaps that when
> the discussion is started again in a couple of months I am more interested in a lengthy reply.

Hohum. Please remove me from CC for any further discussion.

	-Mike

