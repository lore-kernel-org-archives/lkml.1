Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbYFMOB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbYFMOB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYFMOBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:01:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58352 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbYFMOBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:01:49 -0400
Date: Fri, 13 Jun 2008 17:00:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #10821] rt25xx: lock dependancy warning, association
	failure, and kmalloc corruption
Message-ID: <20080613140037.GC21341@cs181133002.pp.htv.fi>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.pGD.22vSIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dCRO4tbfLzK.A.pGD.22vSIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
>...
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
> Subject		: rt25xx: lock dependancy warning, association failure, and kmalloc corruption
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2008-05-29 14:30 (10 days old)


Ivo, can you look at this 2.6.26-rc regression?


TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

