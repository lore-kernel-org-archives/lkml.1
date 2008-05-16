Return-Path: <linux-kernel-owner+w=401wt.eu-S1763860AbYEPTLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763860AbYEPTLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763165AbYEPTKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:10:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44845 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671AbYEPTKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:10:46 -0400
Date: Fri, 16 May 2008 12:08:54 -0700
From: Greg KH <greg@kroah.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Matthias Urlichs <smurf@smurf.noris.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Augusto Campos <brain@matrix.com.br>
Subject: Re: [PATCH][OPTION]: Add id for Onda MSA501HS HSDPA modem
Message-ID: <20080516190854.GC28415@kroah.com>
References: <20080516184140.GA8111@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516184140.GA8111@ghostprotocols.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 03:41:40PM -0300, Arnaldo Carvalho de Melo wrote:
> Hi Matthias,
> 
> 	Please consider adding the following USB product id to the
> option GSM modem driver.
> 
>         Using the generic usbserial kernel driver I can only get to
> ~490 Kbit/s, while when using your excellent driver I'm being able to
> saturate the 1 Mbit/s bandwidth I subscribed from TIM WEB here in Brazil.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Hm, I already added this device to the driver a few days ago, but it was
under a different section and name.  I'll go fix it up to use these
defines as that makes more sense, sorry for missing that previously.

thanks,

greg k-h
