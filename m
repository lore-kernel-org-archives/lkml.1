Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZGHWif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZGHWif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZGHWi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:38:28 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4178 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbZGHWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:38:27 -0400
Subject: Re: good example of a tty driver
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>, Eng.Linux@digi.com,
       "Kilau, Scott" <Scott.Kilau@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090702183149.GA11720@kroah.com>
References: <D77CBB49-A340-4282-9ACF-2172D1BB9E43@kernel.crashing.org>
	 <20090702192744.029620ae@lxorguk.ukuu.org.uk>
	 <20090702183149.GA11720@kroah.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 15:38:07 -0700
Message-Id: <1247092687.25028.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 11:31 -0700, Greg KH wrote:
> On Thu, Jul 02, 2009 at 07:27:44PM +0100, Alan Cox wrote:
> > On Thu, 2 Jul 2009 11:48:09 -0500
> > Kumar Gala <galak@kernel.crashing.org> wrote:
> > > Thankfully the have a GPL driver but it was last updated against 2.6.23:
> > > http://www.connectivity.avocent.com/drivers/esp_serial_hubs/dd64e069.asp
> > > However I've never worked on any tty drivers so its a bit black magic  
> > > at this point.  I was hoping that an example would at least get me  
> > > able to bring the driver up to a point that we can get it into the  
> > > staging tree.
> > I would make it build, chuck it in the staging tree and go from there
> That sounds good to me as well.  Kumar, feel free to send me a patch :)

I was playing around the the digi dgap driver which is out of tree.

Scott, do you or Digi have any objections in putting the dgap driver
into staging as well?

