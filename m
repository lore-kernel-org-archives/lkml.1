Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZGaLQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZGaLQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZGaLQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:16:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48958 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZGaLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <20090730185044.GH3058@console-pimps.org>
References: <1248954848.5396.6.camel@localhost> <20090730124543.GF3058@console-pimps.org> 
	<bd5b16740907300855y2ee0f76fv5886606fcee241b7@mail.gmail.com> 
	<20090730185044.GH3058@console-pimps.org>
From: Ohad Ben-Cohen <ohad@bencohen.org>
Date: Fri, 31 Jul 2009 14:16:12 +0300
Message-ID: <bd5b16740907310416u635df504raa4b6308d361a614@mail.gmail.com>
Subject: Re: [PATCH] sdio: add CD disable support
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, ian@mnementh.co.uk,
       pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es,
       Adrian Hunter <adrian.hunter@nokia.com>, Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, Jul 30, 2009 at 9:50 PM, Matt Fleming<matt@console-pimps.org> wrote:
> As David has already said, both comments need fixing up. It is the host
> controller driver that decides whether to disable the DAT[3] pull-up,
> not the card. If you make those changes then you can add my Acked-by.

I'm posting a follow-up patch with the fixes and your Ack,

will appreciate your second review.

Thanks,
Ohad.
