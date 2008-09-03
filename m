Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYICVgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYICVgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYICVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:36:12 -0400
Received: from styx.suse.cz ([82.119.242.94]:48776 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752720AbYICVgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:36:12 -0400
Date: Wed, 3 Sep 2008 23:36:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <20080903213258.GC14620@khazad-dum.debian.net>
Message-ID: <alpine.LNX.1.10.0809032334270.23448@jikos.suse.cz>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Henrique de Moraes Holschuh wrote:

> I fell I need to warn you guys that you are likely breaking machines 
> that match that DMI info but have a newer BIOS, unless they use 
> different BIOSes (not enough data without a full dmidecode output from 
> the other machine).

I would dare to say "breaking". Just using 'nomux' shouldn't really 
_break_ anything, unless the BIOS is somehow seriously hosed.

-- 
Jiri Kosina
SUSE Labs
