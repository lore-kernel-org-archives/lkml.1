Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363Ab0ART7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0ART7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731Ab0ART7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:59:33 -0500
Received: from mail.perches.com ([173.55.12.10]:1269 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab0ART7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:59:32 -0500
Subject: Re: [PATCH] video/matrox: Checkpatch cleanups for matroxfb_crtc2.c
From: Joe Perches <joe@perches.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <201001182027.29805.PeterHuewe@gmx.de>
References: <201001181934.49519.PeterHuewe@gmx.de>
	 <1263842269.26846.122.camel@Joe-Laptop.home>
	 <201001182027.29805.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 11:59:30 -0800
Message-ID: <1263844770.26846.134.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 20:27 +0100, Peter Hüwe wrote:
> the reason behind this change was that spaces and tabs were mixed for 
> indention. 

Checkpatch isn't gospel and isn't always right.

There should be room for taste preference here
and I think whatever Petr V's is should prevail.

> How about this indention? Would this be better?

Well, I don't think so, but others will have different opinions.


