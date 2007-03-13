Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbXCMSgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbXCMSgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXCMSgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:36:41 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:33302 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbXCMSgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:36:40 -0400
Date: Tue, 13 Mar 2007 14:36:33 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
In-reply-to: <200703130428.11014.gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Message-id: <200703131436.33509.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007, Gene Heskett wrote:
>Greetings;
>Someone suggested a fresh thread for this.
>
>I now have my scripts more or less under control, and I can report that
>kernel-2.6.20.1 with no other patches does not exhibit the undesirable
>behaviour where tar thinks its all new, even when told to do a level 2
> on a directory tree that hasn't been touched in months to update
> anything.
>
>Next up, 2.6.20.2, plain and with the latest RDSL-0.30 patch.

And amanda/tar worked normally for 2.6.20.2 plain.

Next up, 2.6.21-rc1 if it will build here.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Politics:  A strife of interests masquerading as a contest of principles.
The conduct of public affairs for private advantage.
-- Ambrose Bierce
