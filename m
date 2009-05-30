Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbZE3LqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbZE3LqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbZE3LqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:46:07 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59624 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbZE3LqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RaRwnIseoAUSjG47SO5/10UC46KTJDcgRElSvhPHaOVQMo5fF774xS6xxTswj5jz1q
         ZMhvgkBuqp4Nprol38qcvSPPOlmOYL9nUs5d80q9lAEU9zXUprDE6Gnnmt7+ePbrqTEm
         q+fcwO11uXaausc33EP1ufzhdFeWY+TRHHtjU=
MIME-Version: 1.0
In-Reply-To: <4A2109C7.5080009@f2s.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	 <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
	 <4A2109C7.5080009@f2s.com>
Date: Sat, 30 May 2009 13:46:06 +0200
Message-ID: <74d0deb30905300446k606289cctc56efe68fdc7193d@mail.gmail.com>
Subject: Re: [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: ian@mnementh.co.uk
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 12:26 PM, Ian molton <spyro@f2s.com> wrote:
> Acked-by: Ian Molton <ian@mnementh.co.uk>
>
> Works fine on the e-series machines, however checkpatch has a few warnings
> about overlength lines. I dont think they are a problem, but its not my call
> - Pierre?

Yes, if you prefer I'll resend with those lines broken up.

regards
Philipp
