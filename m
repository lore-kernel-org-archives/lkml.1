Return-Path: <linux-kernel-owner+w=401wt.eu-S932326Ab0ANTzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0ANTzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300Ab0ANTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:55:04 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:61007 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0ANTzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:55:02 -0500
Subject: Re: [PATCH] regulator: Add 'start-up time' to fixed voltage
 regulators
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Quadros Roger (Nokia-D/Helsinki)" <roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4DC66C.5050106@nokia.com>
References: <4B4DB562.2080601@nokia.com>
	 <20100113120327.GB27473@rakim.wolfsonmicro.main>
	 <4B4DB94E.8080602@nokia.com>
	 <20100113122612.GC27473@rakim.wolfsonmicro.main>
	 <4B4DC66C.5050106@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 19:54:51 +0000
Message-ID: <1263498891.2735.44.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 15:11 +0200, Adrian Hunter wrote:
> From bd97e65b280be528239e3932da8be512ce7785ed Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Tue, 12 Jan 2010 12:25:13 +0200
> Subject: [PATCH] regulator: Add 'start-up time' to fixed voltage regulators
> 
> Add a field to specify a delay for the start-up time of
> a fixed voltage regulator.
> 

Applied.

Thanks

Liam

