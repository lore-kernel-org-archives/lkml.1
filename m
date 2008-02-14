Return-Path: <linux-kernel-owner+w=401wt.eu-S1763758AbYBNSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763758AbYBNSex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762404AbYBNSeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:34:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761752AbYBNSen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:34:43 -0500
Message-ID: <47B488D3.5050209@zytor.com>
Date: Thu, 14 Feb 2008 10:30:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>	 <1202988844.26435.4.camel@muff> <1203008490.30818.69.camel@localhost.localdomain>
In-Reply-To: <1203008490.30818.69.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> 
> Agreed. Probably the same deal as the compression format, i.e. use the
> magic number but only ELF is possible today (even less likely to change
> than the compression format I guess...).
> 

Quite.

	-hpa
