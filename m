Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912Ab0AWX0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0AWX0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 18:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732Ab0AWXZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 18:25:59 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:62964 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0AWXZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 18:25:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=w9SIqkwBQOTCfhMorUg5bS6XvBhZEGtqqBxbFmPPqhqsjRQ+ve3kHjEjSM+hkK2BAa
         y8n9oC4a4Kt4weGCLakx+FNSbBV4oIs169CXX+Axg3Fl5blhvpJ27COikomZv4z4sYzE
         W0O4dWTBTFfFMtypmkJwD+knR08m7daABqrKI=
Date: Sun, 24 Jan 2010 01:25:58 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/29] move acornfb's probe function to .devinit.text
Message-ID: <20100123232558.GA4146@x200>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1264278937-19675-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264278937-19675-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 09:35:09PM +0100, Uwe Kleine-König wrote:
>  drivers/video/acornfb.c |    2 +-

gods, can you just send one patch for all framebuffer drivers?
