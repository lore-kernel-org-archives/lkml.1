Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZJBHVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZJBHVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZJBHVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:21:01 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:35773 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753481AbZJBHVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:21:01 -0400
Message-ID: <4AC5A9BF.8080903@simtec.co.uk>
Date: Fri, 02 Oct 2009 08:20:31 +0100
From: Ben Dooks <ben@simtec.co.uk>
Organization: Simtec Electronics, UK
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
       Ramax Lo <ramaxlo@gmail.com>,
       Nelson Castillo <arhuaco@freaks-unidos.net>
Subject: Re: [PATCH 19/34] move s3c_adc_remove to .devexit.text
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-19-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1254385718-14254-19-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> The function s3c_adc_remove is used only wrapped by __devexit_p so define
> it using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ben Dooks <ben-linux@fluff.org>
Acked-By: Ben Dooks <ben@simtec.co.uk>
> Cc: Ramax Lo <ramaxlo@gmail.com>
> Cc: Nelson Castillo <arhuaco@freaks-unidos.net>
> Cc: linux-kernel@vger.kernel.org

-- 
Ben Dooks, Software Engineer, Simtec Electronics

http://www.simtec.co.uk/
