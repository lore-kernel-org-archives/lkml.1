Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbYBTVIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbYBTVIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYBTVH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:07:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43751 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYBTVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:07:56 -0500
Date: Wed, 20 Feb 2008 13:07:36 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080220130736.4ccb2687@laptopd505.fenrus.org>
In-Reply-To: <1203541122.6243.103.camel@lappy>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<1203531375.6243.52.camel@lappy>
	<20080220103940.0a0b5ce0@laptopd505.fenrus.org>
	<1203533622.6243.55.camel@lappy>
	<20080220112655.18011dab@laptopd505.fenrus.org>
	<1203541122.6243.103.camel@lappy>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 21:58:42 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Wed, 2008-02-20 at 11:26 -0800, Arjan van de Ven wrote:
> 
> > feel free to reinvent a whole GUI just to avoid a 200 line kernel
> > module. sysprof is here. it works. 
> 
> > the gui is REALLY nice.
> 
> I guess we have to agree to disagree here. Its plain useless from my
> POV.

that's fine. Different tools for different people. sysprof isn't aimed
at kernel developers.

"If all you have is an allen wrench, everything looks like Ikea"

it's ok to have different tools for really different things


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
