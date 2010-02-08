Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0BHSvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:51:53 -0500
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:58738 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab0BHSvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:51:52 -0500
From: Frans Pop <elendil@planet.nl>
To: ccube <friends@ccube.de>
Subject: Re: [PATCH] option.c added DELL wireless HSDPA 5540 Modem
Date: Mon, 8 Feb 2010 19:51:49 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4B705244.2010606@ccube.de>
In-reply-To: <4B705244.2010606@ccube.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002081951.50321.elendil@planet.nl>
X-OriginalArrivalTime: 08 Feb 2010 18:51:50.0961 (UTC) FILETIME=[C636CA10:01CAA8EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ccube wrote:
> i really dont know if everything is correct.
> This is my first submit into this mailing list.
> I added support for my HSDPA UMTS-card.
> Perhaps you can check! ;)

There are two main problems with your patch.

1) The lines in the patch have been line-wrapped by your mail client.
   This means the patch will not apply.
2) The patch is not signed off, which prevents inclusion.

Please see Documentation/SubmittingPatches and the other documents 
referenced there.

You should also try to Cc the most relevant maintainers of the code you're 
changing. In this case the linux-usb list (also on vger.kernel.org).

Cheers,
FJP
