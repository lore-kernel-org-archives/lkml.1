Return-Path: <linux-kernel-owner+w=401wt.eu-S1751419AbZGSUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbZGSUKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 16:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZGSUKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 16:10:42 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:52934 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZGSUKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 16:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QvcpQPLM67XYRtJtYLx34zEAkPCpMocza5ZHcYBGfaya/TGzd7CIdQ+TIqSX6pCscZ
         cEoNajyYTGlVE5vzFmb56TBTpTMC7ACYmb/9UCOyq9dnDkAn8Qto0buA30HbEJB9R/Am
         EkZVvyyM5o0If8CyB9XQ/cYvw+DcLd3e+fSyU=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SPI driver for LMS283GF05 LCD
Date: Sun, 19 Jul 2009 22:10:21 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-1-amd64; KDE/4.2.4; x86_64; ; )
Cc: rpurdie@rpsys.net, Andrew Morton <akpm@linux-foundation.org>
References: <200907161004.02552.marek.vasut@gmail.com>
In-Reply-To: <200907161004.02552.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907192210.22033.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 16. července 2009 10:04:02 Marek Vasut napsal(a):
> From b7077676a3016327ca1010d3bbc80a0b9f2742e5 Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Thu, 16 Jul 2009 04:49:47 +0200
> Subject: [PATCH] Samsung LMS283GF05 LCD SPI support
>
> This patch adds support for the SPI part of LMS283GF05 LCD. The LCD uses
> SPI for initialization and powerdown sequences. No further defails are
> specified in the datasheet about the initialization/powerdown sequence,
> just the magic numbers that have to be sent over SPI bus. This LCD can
> be found in the Aeronix Zipit Z2 handheld.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Any update on this one ?
