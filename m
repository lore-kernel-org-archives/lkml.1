Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbXGRTvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbXGRTvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXGRTvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:51:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXGRTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:51:08 -0400
Message-ID: <469E6F1C.1050001@zytor.com>
Date: Wed, 18 Jul 2007 12:50:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andi Kleen <andi@firstfloor.org>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org>
In-Reply-To: <20070718194137.GG11166@waste.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> 
> That's not the point at all.
> 
> Every byte you can shave off the compressed kernel image is another
> byte you can use for userspace on your FLASH.
> 

That wasn't the original poster's point, but yes, that is a real issue.

	-hpa
