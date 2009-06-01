Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZFAFiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZFAFiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZFAFh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:37:57 -0400
Received: from mail-qy0-f130.google.com ([209.85.221.130]:42357 "EHLO
	mail-qy0-f130.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZFAFh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p6HiSTXh9o3Ren00ZRxKuR0bPwj0U/ha7+qVmWvjXrP6RgAczzzPgSGth4iZN9HAqg
         yIzL2qpaDoSlXwHCLjmXo68gchrpnF1nadqwTjvMf0dirDQxIlElmBgWmpB6szJtXCvz
         g47wt0TAcHYWRmcTGPseJDZ79fINq5GHQ6pnc=
MIME-Version: 1.0
In-Reply-To: <1243487718-5423-4-git-send-email-philipp.zabel@gmail.com>
References: <878wkibmv9.fsf@free.fr>
	 <1243487718-5423-4-git-send-email-philipp.zabel@gmail.com>
Date: Mon, 1 Jun 2009 13:37:58 +0800
Message-ID: <f17812d70905312237v33d9758eq3fc92f7330316147@mail.gmail.com>
Subject: Re: [PATCH 3/3] pxa/hx4700: add Maxim 1587A voltage regulator
From: Eric Miao <eric.y.miao@gmail.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Eric Miao <eric.miao@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 1:15 PM, Philipp Zabel <philipp.zabel@gmail.com> wrote:
> On this board, the PXA270 CPU voltage VCC_CORE is provided
> by a Maxim 1587A voltage regulator configured to provide
> 1.55 V maximum voltage for 624 MHz operation.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

Applied to 'pending'.
