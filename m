Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYBRN2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYBRN2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYBRN2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:28:41 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:59117 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276AbYBRN2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:28:41 -0500
Date: Mon, 18 Feb 2008 14:28:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: problem with starting 2.5.26-rc1 and latest git
Message-ID: <20080218142832.3a092dd5@hyperion.delvare>
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
> > (...)

Have you tried upgrading to rc2? I used to have the same problem you
reported, but I was unable to reproduce it since I upgraded to rc2.

-- 
Jean Delvare
