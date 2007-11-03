Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbXKCSJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbXKCSJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXKCSJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:09:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbXKCSJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:09:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas =?iso-8859-15?q?B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-g74521c28: oops during boot [<ffffffff881c03e4>] :power_supply:power_supply_show_property+0x94/0x150
Date: Sat, 3 Nov 2007 19:26:01 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <472C5C2D.9010700@archlinux.org>
In-Reply-To: <472C5C2D.9010700@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711031926.01665.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 3 November 2007 12:31, Thomas Bächler wrote:
> I am trying to boot 2.6.24-rc1-g74521c28 from the linux-2.6 git tree.
> During boot, I get a kernel oops when udevtrigger is running, thus most
> devices are not created and the boot stalls.
> 
> Fortunately, the services are still started (though I don't see anything
> due to missing ttys) and syslog caught the oops. The logfile and config
> are attached.

Can you please attach these files to the bugzilla entry at:

http://bugzilla.kernel.org/show_bug.cgi?id=9299

Thanks,
Rafael
