Return-Path: <linux-kernel-owner+w=401wt.eu-S936186AbXFFWM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186AbXFFWM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXFFWMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:12:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXFFWMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:12:19 -0400
Message-ID: <46673135.30105@zytor.com>
Date: Wed, 06 Jun 2007 15:12:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Bodo Eggert <7eggert@gmx.de>, Andi Kleen <andi@firstfloor.org>,
       tmoore@spatial.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz> <20070606143723.GF10008@csclub.uwaterloo.ca>
In-Reply-To: <20070606143723.GF10008@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> 
> Seems like an improvement to me.  To fully explain how it could be 3 or
> 3.5 or 3.25 or who knows how many GB you can actually use without PAE
> would probably require writing a small novel.  Certainly talking about
> address space instead of amounts of physical memory is more correct.
> 

On some machines it's even just 2 GB.

	-hpa
