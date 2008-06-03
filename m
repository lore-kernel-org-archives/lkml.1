Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYFCBe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYFCBe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 21:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYFCBet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:34:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYFCBet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:34:49 -0400
Message-ID: <48449FAE.70404@zytor.com>
Date: Mon, 02 Jun 2008 18:34:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com>
In-Reply-To: <48447615.5050806@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> With CONSOLE_TRANSLATIONS turned off, this saves about 6K
> on my kernel configured for an ARM development board (OMAP
> 5912 OSK).  In embedded products I'm familiar with,
> console translations are not needed.

On most embedded products I'm familiar with, you wouldn't have virtual 
consoles at all...?

	-hpa
