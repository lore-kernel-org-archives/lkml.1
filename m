Return-Path: <linux-kernel-owner+w=401wt.eu-S969104AbXEIDdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969104AbXEIDdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967303AbXEIDdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:33:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967513AbXEIDdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:33:44 -0400
Date: Tue, 8 May 2007 20:33:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
In-Reply-To: <46413A7E.5050304@garzik.org>
Message-ID: <alpine.LFD.0.98.0705082032591.4062@woody.linux-foundation.org>
References: <46413851.6070505@zytor.com> <46413A7E.5050304@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Jeff Garzik wrote:
> 
> I wonder if this fbdev update is what causes my X session to die?

Not that particular patch, but yeah, it could certainly be the fbdev 
update.

Can you try bisecting it?

		Linus
