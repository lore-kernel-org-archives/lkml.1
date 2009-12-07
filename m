Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbZLGUS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbZLGUS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbZLGUS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:18:58 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56180 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbZLGUS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:18:57 -0500
Message-ID: <4B1D6334.9070004@canonical.com>
Date: Mon, 07 Dec 2009 21:19:00 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Libin Yang <libin.yang@amd.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [041/119] USB: ohci: quirk AMD prefetch for USB
 1.1	ISO transfer
References: <20091206235936.208334321@mini.kroah.org> <20091207000646.961519997@mini.kroah.org> <4B1D277E.207@canonical.com> <20091207164816.GA31258@suse.de>
In-Reply-To: <20091207164816.GA31258@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Dec 07, 2009 at 05:04:14PM +0100, Stefan Bader wrote:
>> Just to verify this, the patch also adds a call to quirk_amd_pll
>> but from the description it is not clear to me this is intended.
> 
> Why not?

Just as the title just states amdprefech and the code adds both quirks.
But ok, its the same upstream and its really better to keep it the same.

-Stefan
