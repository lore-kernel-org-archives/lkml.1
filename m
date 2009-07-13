Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZGMQis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZGMQis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZGMQir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:38:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZGMQir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:38:47 -0400
Date: Mon, 13 Jul 2009 09:35:30 -0700
From: Greg KH <gregkh@suse.de>
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Message-ID: <20090713163530.GA22251@suse.de>
References: <20090713151709.GA1297@lilem.mirepesht>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713151709.GA1297@lilem.mirepesht>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 07:47:09PM +0430, Ali Gholami Rudi wrote:
> Hi,
> 
> Is there any reason for not adding these ioctls to fbdev?  I searched
> the net and couldn't any.  Anyway, these patches simply implement those
> ioctls.

Have you also added the needed 32 vs. 64 bit handlers for these ioctls?

thanks,

greg k-h
