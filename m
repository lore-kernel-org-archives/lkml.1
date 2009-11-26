Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZKZIz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZKZIz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZKZIz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:55:57 -0500
Received: from av12-1-sn2.hy.skanova.net ([81.228.8.185]:54239 "EHLO
	av12-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZKZIz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:55:57 -0500
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Nov 2009 03:55:57 EST
Message-ID: <4B0E3B08.9050004@mocean-labs.com>
Date: Thu, 26 Nov 2009 09:23:36 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>
Organization: Pelagicore AB
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Subject: Re: [PATCH 29/38] move mc33880_remove to .devexit.text
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-17-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-18-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-19-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-21-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-22-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-23-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-24-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-25-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-26-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-27-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-28-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-29-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1259096853-18909-29-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> The function mc33880_remove is used only wrapped by __devexit_p so define
> it using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Richard Röjfors <richard.rojfors@mocean-labs.com>
