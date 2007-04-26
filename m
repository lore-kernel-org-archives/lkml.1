Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXDZQrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXDZQrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXDZQrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:47:42 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:49748 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbXDZQrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:47:41 -0400
Message-ID: <4630D724.70901@gmail.com>
Date: Thu, 26 Apr 2007 18:45:24 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <20070404150231.GE27660@stusta.de>	<4613C963.6070409@gmail.com>	<20070404170016.453d26f1@the-village.bc.nu>	<4613D492.2070404@gmail.com>	<462C7D74.60003@gmail.com>	<1177327476.17026.75.camel@localhost.localdomain>	<Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>	<462CA764.5080401@gmail.com>	<20070425181856.42fcfeb4.akpm@linux-foundation.org>	<463081E5.5010306@gmail.com>	<20070426135426.GM3468@stusta.de>	<4630BD61.2050006@gmail.com> <20070426170050.7b333556@the-village.bc.nu>
In-Reply-To: <20070426170050.7b333556@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2007 06:00 PM, Alan Cox wrote:

>> Tie Alan to his chair and take away his keyboard while we submit patches 
>> removing MODULE_AUTHOR? Or just apply a trivial two line, optional, non 
>> mandatory, patch introducing a MODULE_MAINTAINER? You pick... :-)
> 
> MODULE_AUTHOR is extremely important for licensing enforcement. Removing
> it should not be an option.

Yes, the "choice" was obviously in jest. If you say MODULE_AUTHOR must stay, 
so must it. As said, that just leaves me wanting a way to override it as a 
contact.

Rene.

