Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbYJSPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbYJSPeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 11:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYJSPeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 11:34:11 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:53764 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYJSPeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 11:34:11 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)
Date: Sun, 19 Oct 2008 17:34:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <alpine.DEB.1.10.0810190720210.26990@p34.internal.lan> <alpine.DEB.1.10.0810190728030.26990@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0810190728030.26990@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810191734.11044.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 19. Oktober 2008 13:28:24 schrieb Justin Piszcz:
> 
> On Sun, 19 Oct 2008, Justin Piszcz wrote:
> 
> > With kernel 2.6.27.2, any processes attempting to use USB hang and go into 
> > D-state, I have never had a problem like this before until 2.6.27.2 (I have 
> > not tried 2.6.27.1 or 2.6.27)

Please get sysrq-t of a hang.

	Regards
		Oliver
