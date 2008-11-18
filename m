Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYKRShR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYKRShR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYKRShF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:37:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36583 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYKRShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:37:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49230B3A.2000509@s5r6.in-berlin.de>
Date: Tue, 18 Nov 2008 19:36:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Can you add the staging tree to -next?
References: <20081112235600.GA27554@kroah.com> <Pine.LNX.4.64.0811140825410.11953@anakin> <20081114173258.GC22980@kroah.com>
In-Reply-To: <20081114173258.GC22980@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote on November 14:
> On Fri, Nov 14, 2008 at 08:42:48AM +0100, Geert Uytterhoeven wrote:
>> Apart from the patches you receive against -next, is there any other
>> advantage, giving staging is disabled?
> 
> That is a huge advantage, don't discount it.  My staging tree has over
> 150 patches in it right now, and is quite diverged from what is in
> Linus's tree.  I have been getting the same patches sent over and over
> to fix the same thing that is already resolved in my tree, as the
> developers are working against -next thinking that they were working
> with the latest development tree.

These people are missing that -next is not a development tree.
(Unless final integration tests count still as development.)
-- 
Stefan Richter
-=====-==--- =-== =--=-
http://arcgraph.de/sr/
