Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbXK2QhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbXK2QhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbXK2Qg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:36:57 -0500
Received: from main.gmane.org ([80.91.229.2]:53552 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731AbXK2Qg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:36:56 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: Out of tree module using LSM
Date: Thu, 29 Nov 2007 11:36:47 -0500
Organization: World Organi[sz]ation Of Broken Dreams
Message-ID: <1196354172.6473.52.camel@perihelion>
References: <20071128144156.GA14106@infradead.org>
	 <416908.77038.qm@web36613.mail.mud.yahoo.com>
	 <20071128164613.GA21815@infradead.org>
	 <25290.1196273705@turing-police.cc.vt.edu>
	 <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com>
	 <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
	 <20071129010753.GA19106@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: boston.jonmasters.org
In-Reply-To: <20071129010753.GA19106@kroah.com>
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 17:07 -0800, Greg KH wrote:

> The easiest way is as Al described above, just have the userspace
> program that wrote the file to disk, check it then.

But the problem is that this isn't just Samba, this is a countless
myriad of different applications. And if one of them doesn't support
on-access scanning, then the whole solution isn't worth using.

> There are some nice SAMBA plugins that do just that already out there...

That's really not the problem :-)

Jon.



