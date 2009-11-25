Return-Path: <linux-kernel-owner+w=401wt.eu-S934868AbZKYUHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbZKYUHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933519AbZKYUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:07:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46078 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759208AbZKYUHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:07:14 -0500
Date: Wed, 25 Nov 2009 20:09:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: "Greg KH" <greg@kroah.com>, "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20091125200910.0377bc0c@lxorguk.ukuu.org.uk>
In-Reply-To: <c53e47c966cc5f6c7b3616f9be83ad23.squirrel@intranet.cs.nmsu.edu>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
	<20090818151427.GA6295@kroah.com>
	<ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
	<20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
	<5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
	<20090819191944.23e6e0ee@lxorguk.ukuu.org.uk>
	<3eb87686d834e14f35378d3c3c79fb02.squirrel@intranet.cs.nmsu.edu>
	<20090819193457.538aad95@lxorguk.ukuu.org.uk>
	<c53e47c966cc5f6c7b3616f9be83ad23.squirrel@intranet.cs.nmsu.edu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have the display as a framebuffer device now (based on fbdefio with the
> hid device as the parent).
> 
> Do I really need a separate console device or can I just use fbcon?

fbcon should do what you want.

ALan
