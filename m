Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZFAFj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZFAFj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZFAFjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:39:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:6277 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZFAFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GsZkyYXOfjNFMq7NphiVpJiQLqyJLLkGZMGRSEtp+X/AJl+fMTIWUO37IXkrKsCdaF
         2JW6p8oTEtsTLPTerzFlVr7k9quXLGPU5CUr4jFP1bN88bBKHiLeJAqHyIloCYO+b/+f
         q7jD0kVHPgVcDSR6zPW1WcLegMOLjYvgOjBZw=
MIME-Version: 1.0
In-Reply-To: <87fxeov363.fsf@free.fr>
References: <878wkibmv9.fsf@free.fr>
	 <1243487718-5423-3-git-send-email-philipp.zabel@gmail.com>
	 <87fxeov363.fsf@free.fr>
Date: Mon, 1 Jun 2009 13:39:51 +0800
Message-ID: <f17812d70905312239o753787c1ke5d96d3c70e085a1@mail.gmail.com>
Subject: Re: [PATCH 4/5] pxa/mioa701: add V3 gain configuration for Maxim 1586 
	voltage regulator
From: Eric Miao <eric.y.miao@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Eric Miao <eric.miao@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 2:22 PM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Philipp Zabel <philipp.zabel@gmail.com> writes:
>
>> Maxim 1586 V3 gain can be configured by external resistors
>> (R24, R25) connected to the FB3 pin. To avoid accidental
>> overvoltage, it now requires this gain to be configured
>> explicitly.
>>
>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
>

Applied to 'pending'.
