Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYCLAJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYCLAJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYCLAJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:09:29 -0400
Received: from mail.tuxonice.net ([67.207.135.122]:46637 "EHLO
	mail.tuxonice.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYCLAJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:09:29 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 20:09:29 EDT
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH -mm] kexec jump -v9
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080311232415.GA26320@elf.ucw.cz>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com>  <20080311232415.GA26320@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 11:00:42 +1100
Message-Id: <1205280042.764.28.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2008-03-12 at 00:24 +0100, Pavel Machek wrote: 
> ...OTOH this is probably only chance to eliminate freezer from
> swsusp...

I think eliminating the freezer and having reliable hibernation under
load look like incompatible goals at the moment. Do you see that as 'not
a problem' or have some idea on how that issue can be addressed?

Regards,

Nigel

