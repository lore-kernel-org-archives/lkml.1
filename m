Return-Path: <linux-kernel-owner+w=401wt.eu-S2993080AbXDYUU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993080AbXDYUU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993084AbXDYUU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:20:27 -0400
Received: from gw.goop.org ([64.81.55.164]:53638 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993082AbXDYUUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:20:24 -0400
Message-ID: <462FB825.7040606@goop.org>
Date: Wed, 25 Apr 2007 13:20:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ian Pratt <ian.pratt@xensource.com>, lkml <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
References: <20070423215638.563901986@goop.org> <200704252143.48363.ak@suse.de> <462FB42F.5070503@goop.org> <200704252217.06381.ak@suse.de>
In-Reply-To: <200704252217.06381.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The major problem was that it didn't compile on x86-64.
>   

Ah, OK.  I don't think you mentioned that.  I'll fix that up.

> And a few uglities in there
>   

Such as?

    J
