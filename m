Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYEEJJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYEEJJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYEEJIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:08:54 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45584 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbYEEJIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:08:54 -0400
Date: Mon, 5 May 2008 11:09:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCH] modpost: i2c aliases need no trailing wildcard
Message-ID: <20080505090929.GA29310@uranus.ravnborg.org>
References: <20080502203721.70c5dc09@hyperion.delvare> <200805051009.06159.rusty@rustcorp.com.au> <20080505104816.1f666613@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505104816.1f666613@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Still, there's nothing wrong with this patch, happy for you to send it.
> > 
> > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Thanks,

The patch is in -linus already so I cannot add the "Acked-by".

	Sam
