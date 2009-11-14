Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbZKNAhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbZKNAhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbZKNAhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:37:03 -0500
Received: from 42.mail-out.ovh.net ([213.251.189.42]:58960 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932313AbZKNAhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:37:01 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 19:37:01 EST
Date: Sat, 14 Nov 2009 01:28:27 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com, linux@arm.linux.org.uk, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] atmel_lcdfb Kconfig: remove long dependency line
Message-ID: <20091114002827.GB4441@game.jcrosoft.org>
References: <29424085870c8c8cc3fe9d6e1f382a24f8a9ca2b.1257263893.git.nicolas.ferre@atmel.com>
 <1258130398-13737-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258130398-13737-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 18102781653338991468
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:39 Fri 13 Nov     , Nicolas Ferre wrote:
> Many Atmel SOC are embedding a LCD controller. This patch removes the long
> dependency line for this Atmel LCD framebuffer driver configuration entry.
> The HAVE_FB_ATMEL configuration option is located in the video Kconfig file
> as it may be setup by ARM/AT91 and AVR32 chips.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
