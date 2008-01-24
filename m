Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYAXTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYAXTzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYAXTzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:55:08 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:46234 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYAXTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:55:06 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Date: Thu, 24 Jan 2008 20:57:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, Wilco Beekhuizen <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <20080124180313.GA16006@kroah.com> <Pine.LNX.4.64.0801242122200.17171@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0801242122200.17171@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801242057.59226.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Januar 2008 20:25:35 schrieb Pekka J Enberg:
> Well, that's how it works for all other music players (especially ones 
> that support USB storage natively). But anyway, here's a skeleton driver 
> for what I was proposing in case someone is interested.
> 

Are you proposing to mount a _character_ device?

	Regards
		Oliver

