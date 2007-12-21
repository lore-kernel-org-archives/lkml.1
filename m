Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbXLUNI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbXLUNI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXLUNIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:08:51 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44412 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbXLUNIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:08:50 -0500
Date: Fri, 21 Dec 2007 16:08:25 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ville Syrjala <syrjala@sci.fi>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] w1-gpio: Add GPIO w1 bus master driver (v2)
Message-ID: <20071221130825.GA18569@2ka.mipt.ru>
References: <11982411462688-git-send-email-syrjala@sci.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11982411462688-git-send-email-syrjala@sci.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 02:45:46PM +0200, Ville Syrjala (syrjala@sci.fi) wrote:
> Add a GPIO 1-wire bus master driver. The driver used the GPIO API to
> control the wire and the GPIO pin can be specified using platform data
> similar to i2c-gpio. The driver was tested with AT91SAM9260 + DS2401.
> 
> Signed-off-by: Ville Syrjala <syrjala@sci.fi>

This looks ok, thank you!
Feel free to add my ack or signed-off.

Andrew, please apply.

-- 
	Evgeniy Polyakov
