Return-Path: <linux-kernel-owner+w=401wt.eu-S1765646AbXEVJ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765646AbXEVJ3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXEVJ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:29:46 -0400
Received: from ires.in2p3.fr ([193.48.86.184]:47811 "EHLO IReS.in2p3.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbXEVJ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:29:45 -0400
Message-ID: <4652B7B8.9030503@free.fr>
Date: Tue, 22 May 2007 11:28:24 +0200
From: Goulven Guillard <lecotegougdelaforce@free.fr>
Reply-To: lecotegougdelaforce@free.fr
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>, trenn@suse.de,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
References: <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <20070522090636.GO10714@elf.ucw.cz> <20070522091631.GA23309@srcf.ucam.org>
In-Reply-To: <20070522091631.GA23309@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/22/2007 11:16 AM, Matthew Garrett a déclaré :
> On Tue, May 22, 2007 at 11:06:36AM +0200, Pavel Machek wrote:
> 
>> We need to ignore trip point updates from BIOS, and we need to poll
>> thermals when use overrides trip points. That's expected. Plus I've
>> yet to see platform actually updating the trip points.
> 
> Try any recent HP bios.
> 

man cron... ;-)





-- 
    ~~
   |Oo|   La banquise fond !!! Adoptez un pingouin...
  /|\/|\
   |__|            => http://doc.ubuntu-fr.org/
   ^__^
~~~|  |~~~








