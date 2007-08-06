Return-Path: <linux-kernel-owner+w=401wt.eu-S1764964AbXHFNN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964AbXHFNN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763801AbXHFNNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:13:22 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:33444 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbXHFNNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:13:21 -0400
Message-ID: <46B71DBF.7000000@gmail.com>
Date: Mon, 06 Aug 2007 15:10:23 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Indan Zupancic <indan@nul.nu>, teresa@kvitka.net,
       Andi Kleen <andi@firstfloor.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dmitry.torokhov@gmail.com, dtor@mail.ru
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <p73abtbpk2s.fsf@bingen.suse.de> <46B06815.10200@gmail.com> <46470.81.207.0.53.1185971693.squirrel@secure.samage.net> <46B0818F.10204@gmail.com> <49653.81.207.0.53.1185973640.squirrel@secure.samage.net> <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com> <46850.81.207.0.53.1185980760.squirrel@secure.samage.net> <20070801150939.GA24710@elte.hu> <52091.81.207.0.53.1185982005.squirrel@secure.samage.net> <20070806071200.GC5359@elte.hu>
In-Reply-To: <20070806071200.GC5359@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2007 09:12 AM, Ingo Molnar wrote:

> * Indan Zupancic <indan@nul.nu> wrote:
> 
>> All right, how would you debug it? Give us some insight in how to 
>> solve hard to trigger, happens at most only a few times a day, 
>> annoying input bug? I thought the mouse warping was fixed after 23-rc1 
>> and that input locking patch, but alas, the third day it happened 
>> again.
> 
> i've got no idea how to debug such input bugs best, but, as a starting 
> point, i've Cc:-ed the current maintainer of the input subsystem :-)

FWIW, I haven't experienced my "stuck delete" key anymore -- "since using 
CFS v19.1", but that might very well just be coincedence. If anyone 
wants/needs me to, I'll try to debug it, but for now I seem to be fine again.

Now all I need to know is whether or not moving thunderbird's windows around 
is expected to leave such an enormous non-repainting visual trail on the 
screen...

I believe I'm concluding that I'm not all together fond of the "new" modular 
X.org.

Rene.

