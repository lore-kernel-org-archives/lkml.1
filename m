Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0BLL7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:59:12 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:54392 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab0BLL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:59:09 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: usbhid control queue full, due to stuck control request
Date: Fri, 12 Feb 2010 12:59:08 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: David Fries <david@fries.net>, USB list <linux-usb@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100206172051.GA22311@spacedout.fries.net> <201002120835.36908.oliver@neukum.org> <alpine.LNX.2.00.1002121256500.30967@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1002121256500.30967@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002121259.08146.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. Februar 2010 12:57:11 schrieb Jiri Kosina:
> On Fri, 12 Feb 2010, Oliver Neukum wrote:
> 
> > > Oliver Neukum, this is based on your patch, do you agree with the
> > > changes?
> > 
> > I do agree.
> 
> Thanks a lot guys for tracking this down and fixing it. I have applied the 
> patch.

This being a fix for broken hardware it should go into stable, too.
Would you forward it?

	Regards
		Oliver
