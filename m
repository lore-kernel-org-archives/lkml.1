Return-Path: <linux-kernel-owner+w=401wt.eu-S1762199AbZFXUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbZFXUhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZFXUhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:37:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:30288 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZFXUhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LiRqGHAnnu288lRFDle/QYzmVaLmCiBhPSH3w8VraokSxP2Wc+YE2jE5dhdKEky2IF
         rhTgiXri/zjYzt++gyTHnPa1VC5AyxSNgPpLcWd1IaP5Vi9qrppOT+gBCNl4u6h34i2r
         5RSKPpWL4hX9rkIfx0VKmH1+b1MudgZ9VfFHU=
MIME-Version: 1.0
In-Reply-To: <4A41F780.60000@atmel.com>
References: <4A41F780.60000@atmel.com>
Date: Wed, 24 Jun 2009 13:37:34 -0700
X-Google-Sender-Auth: 95699a0e2dbd73f4
Message-ID: <e9c3a7c20906241337r524bbe32ua93e6e7859dc18f0@mail.gmail.com>
Subject: Re: dmaengine: update of at_hdmac
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 2:53 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
> Hi,
>
> I would like to update the at_hdmac dmaengine driver. I have submitted
> it long ago but did not manage to follow it for mainline inclusion at
> that time.
>
> Can you tell me to which git tree I must base my update upon ?
> - linux-next
> - djbw/async_tx.git (which branch)

The 'next' branch of djbw/async_tx.git is where dmaengine patches are
staged before they hit Linus' tree.  Be aware that it is occasionally
rebased.

Regards,
Dan
