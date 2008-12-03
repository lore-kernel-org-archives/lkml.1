Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYLCVkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYLCVkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYLCVjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:39:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLCVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:39:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 000/104] 2.6.27-stable review
Date: Wed, 3 Dec 2008 22:39:13 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20081203194725.GA8950@kroah.com>
In-Reply-To: <20081203194725.GA8950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812032239.14280.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday, 3 of December 2008, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.27.8 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> And yes, there are a lot of patches here, the big series are:
> 	- cifs data corruption patches
> 	- pci hotplug slot patches to fix the most common warning
> 	  showing up on kerneloops.org
> 	- ext4 bugfixes
> 
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.
> 
> Responses should be made by Friday, December 5, 20:00:00 UTC.  Anything
> received after that time might be too late.

The following ACPI commits are also -stable material IMO:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=65df78473ffbf3bff5e2034df1638acc4f3ddd50
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=558073dd56707864f09d563b64e7c37c021e89d2
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b4d469228a92a00e412675817cedd60133de38a
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=40599072dca3ec7d4c9ff8271978be169f974638

Thanks,
Rafael
