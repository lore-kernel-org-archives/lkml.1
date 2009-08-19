Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZHSSdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZHSSdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbZHSSdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:33:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56730 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbZHSSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:33:49 -0400
Date: Wed, 19 Aug 2009 19:34:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: "Greg KH" <greg@kroah.com>, "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20090819193457.538aad95@lxorguk.ukuu.org.uk>
In-Reply-To: <3eb87686d834e14f35378d3c3c79fb02.squirrel@intranet.cs.nmsu.edu>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
	<20090818151427.GA6295@kroah.com>
	<ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
	<20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
	<5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
	<20090819191944.23e6e0ee@lxorguk.ukuu.org.uk>
	<3eb87686d834e14f35378d3c3c79fb02.squirrel@intranet.cs.nmsu.edu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 160x43 --- The same as the G15 and MX5000 keyboards. In fact, it takes the
> same bitmap pattern as the keyboards.
> 
> 160x43 is small, but some graphics are definitely possible, console/text
> is certainly possible.

Ultimately it should probably also create a console device of itself, but
its not something trivial to do and I really wouldn't bother about it
until it works in current form if ever...

Mind you a keyboard that has the display built in would be really useful
for poking around server boxes on racks.

Alan
