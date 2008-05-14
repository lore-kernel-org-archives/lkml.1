Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYENAzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYENAzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYENAy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:54:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40475 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbYENAyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:54:55 -0400
Date: Wed, 14 May 2008 09:52:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: memory_hotplug: always initialize pageblock bitmap.
Message-Id: <20080514095256.741fe70a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080513185242.GA6465@osiris.boeblingen.de.ibm.com>
References: <20080509060609.GB9840@osiris.boeblingen.de.ibm.com>
	<20080509153910.6b074a30.kamezawa.hiroyu@jp.fujitsu.com>
	<20080510124501.GA4796@osiris.boeblingen.de.ibm.com>
	<20080512105500.ff89c0d3.kamezawa.hiroyu@jp.fujitsu.com>
	<20080512181928.cd41c055.kamezawa.hiroyu@jp.fujitsu.com>
	<20080513115825.GB12339@osiris.boeblingen.de.ibm.com>
	<20080513185242.GA6465@osiris.boeblingen.de.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 20:52:42 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> Oops... the patch is tested and works for me. However it was not Signed-off
> by Andrew. And in addition I forgot to add [PATCH] to the subject.
> Sorry about that!
> 
> If all agree that this patch is ok it should probably also go into
> -stable, since it fixes the above mentioned regression.
> 
Thank you very much! The patch seems ok to me.
(But I cannot test this until my box is available...)

If other memory-hotplug guys say ok, I have no objection to -stable.

Thanks,
-Kame

