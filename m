Return-Path: <linux-kernel-owner+w=401wt.eu-S1751361AbZKAJvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbZKAJvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 04:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZKAJvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 04:51:11 -0500
Received: from www84.your-server.de ([213.133.104.84]:33779 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZKAJvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 04:51:10 -0500
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <20091031191040.GB15121@kroah.com>
References: <1256391194.7362.7.camel@wall-e>
	 <20091030222447.GA11671@kroah.com> <1256975440.32191.2.camel@wall-e>
	 <20091031191040.GB15121@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 01 Nov 2009 10:50:56 +0100
Message-ID: <1257069056.3975.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 31.10.2009, 12:10 -0700 schrieb Greg KH:
> 
> I realize it fixes all current usages of kfifo, which is why I offered
> to take it through my driver-core tree so it has a path into Linus's
> tree for the 2.6.33 kernel release.  Unless you are submitting it some
> other way?
> 

Andrew's last plan was merge it after the linux kernel hit 2.6.32-rc7. 

Stefani


