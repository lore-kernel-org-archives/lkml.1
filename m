Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039Ab0AQO57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0AQO57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847Ab0AQO56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:57:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:41606 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab0AQO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:57:57 -0500
Date: Sun, 17 Jan 2010 06:58:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
Message-ID: <20100117065803.6e5e089e@infradead.org>
In-Reply-To: <20100115180341.GA12146@kroah.com>
References: <1263505677.2074.2.camel@yio.site>
	<20100115065638.005ac690@infradead.org>
	<20100115180341.GA12146@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010 10:03:41 -0800
Greg KH <greg@kroah.com> wrote:
> > removing experimental is fine... but setting it by default is a bit
> > over the top and very inconsistent with how the 'default' option is
> > used.
> 
> Why?  

because the convention is that we use "default y" only for those things
that used to be on, and are now turned into a config option.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
