Return-Path: <linux-kernel-owner+w=401wt.eu-S932971AbYECSDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbYECSDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYECSDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:03:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37646 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183AbYECSDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:03:45 -0400
Date: Sat, 3 May 2008 20:04:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Kay Sievers <kay.sievers@vrfy.org>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCH] modpost: i2c aliases need no trailing wildcard
Message-ID: <20080503180420.GA17990@uranus.ravnborg.org>
References: <20080502203721.70c5dc09@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502203721.70c5dc09@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 08:37:21PM +0200, Jean Delvare wrote:
> Hi all,
> 
> [Once more with Sam's address fixed, sorry for the noise.]
> 
> Not all device types need a wildcard at the end of their module
> aliases. In particular, for i2c module aliases, the trailing wildcard
> is not only unneeded, it could also cause the wrong driver to be
> loaded.
...
Hi Jean.

Do you expect me to take this via kbuild.git?

	Sam
