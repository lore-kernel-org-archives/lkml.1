Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbXEVB5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbXEVB5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbXEVB5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:57:06 -0400
Received: from outbound-mail-73.bluehost.com ([69.89.20.8]:38474 "HELO
	outbound-mail-73.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757286AbXEVB5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:57:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Mon, 21 May 2007 18:56:56 -0700
User-Agent: KMail/1.9.6
Cc: "Jeff Garzik" <jeff@garzik.org>, "Jesse Barnes" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <465228E2.1030405@garzik.org> <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
In-Reply-To: <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211856.56228.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Jon Smirl wrote:
> I am not asking that these features be implemented today. I am asking
> that enough planning go into the architecture today to make sure that
> these features can be built in the future without tearing up the
> graphics system for a third time.
>
> This is the essence of my complaint about this patch. The patch
> introduces a new low level graphics API to the kernel. Once we put an
> API in it is basically impossible to get it back out. I am not
> convinced that enough planning has gone into this API yet.

Jon, that's why I'm posting this stuff in the first place! :)  Again, if 
you have specific problems with the proposed interfaces (problems that 
would preclude your wishlist from being fully implementable), please let 
me know (preferably with specifics).

Thanks,
Jesse
