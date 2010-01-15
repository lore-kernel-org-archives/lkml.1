Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0AOO4i (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192Ab0AOO4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:56:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:33034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab0AOO4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:56:37 -0500
Date: Fri, 15 Jan 2010 06:56:38 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
Message-ID: <20100115065638.005ac690@infradead.org>
In-Reply-To: <1263505677.2074.2.camel@yio.site>
References: <1263505677.2074.2.camel@yio.site>
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

On Thu, 14 Jan 2010 22:47:57 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
> default
> 
> All major distros enable devtmpfs on recent systems, so remove
> the EXPERIMENTAL flag, and enable it by default to reflect how it
> is used today.

removing experimental is fine... but setting it by default is a bit
over the top and very inconsistent with how the 'default' option is
used.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
