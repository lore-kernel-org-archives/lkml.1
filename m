Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbXGIWzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbXGIWzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbXGIWyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:54:54 -0400
Received: from smtp141.iad.emailsrvr.com ([207.97.245.141]:33426 "EHLO
	smtp141.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbXGIWyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:54:54 -0400
Message-ID: <4692BC61.9070500@gentoo.org>
Date: Mon, 09 Jul 2007 18:53:21 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com>
In-Reply-To: <46912E09.2070806@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> The patch should be fine for 2.6.22, but for -mm, the code this patches
> doesn't even exist with git-newsetup; nor is there a CONFIG_VIDEO_SELECT
> which could impede the production of the VESA version.
> 
> What does your .config look like?

https://bugs.gentoo.org/attachment.cgi?id=124339&action=view

Daniel

