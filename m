Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZI2CB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZI2CB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 22:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZI2CB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 22:01:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53919 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZI2CB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 22:01:27 -0400
Message-ID: <4AC16A70.2020300@pobox.com>
Date: Mon, 28 Sep 2009 22:01:20 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dirk Hohndel <hohndel@infradead.org>
CC: Jin Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] trivial fix of a very frequent spelling mistake
References: <20090929015607.GA18220@bombadil.infradead.org>
In-Reply-To: <20090929015607.GA18220@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2009 09:56 PM, Dirk Hohndel wrote:
> something-bility is spelled as something-blity
> so a grep for 'blit' would find these lines
>
> I broke this one out from the rest as it actually changes
> the output of a kernel message - so it could in theory
> change the behavior of tools that parse that ouput
>
> Jeff, can you sign-off / NAK this, please?
>
> Signed-off-by: Dirk Hohndel<hohndel@infradead.org>
> ---
>   drivers/ata/pata_ali.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

Yep, will send in the upcoming bug fix push...


