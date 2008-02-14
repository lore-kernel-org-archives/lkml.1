Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbYBNWB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbYBNWB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYBNWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:01:09 -0500
Received: from smtp-107-backup.noc.nerim.net ([62.4.17.107]:2100 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757395AbYBNWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:01:08 -0500
Date: Thu, 14 Feb 2008 23:01:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: problem with starting 2.6.25-rc1 and latest git
Message-ID: <20080214230103.0480d35f@hyperion.delvare>
In-Reply-To: <200802140027.35102.m.kozlowski@tuxland.pl>
References: <200802132316.03155.m.kozlowski@tuxland.pl>
	<200802140027.35102.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 00:27:34 +0100, Mariusz Kozlowski wrote:
> Of course there is a typo in the subject :)
> 
> 2.5.25-rc1 -> 2.6.25-rc1
> 
> > Hello,
> > 
> > 	I tried 2.6.25-rc1 and latest git on my laptop (x86 32bit) and have a problem.
> > Linux boots but with huge delay due to some issue with loading usb modules.
> > Udev complains:
> > 
> > 'Could not lock modprobe uhci_hcd'
> > 'Could not lock modprobe yenta_socket'
> > 'Unknown symbol usb_*'
> > 'Gave up waiting for init of module usbcore'

FWIW: I have the exact same problem here, running 2.6.25-rc1-git3 on x86_64.
Distribution is openSuse 10.2, module-init-tools version 3.2.2, udev 103.
I can do any test you want me to.

-- 
Jean Delvare
