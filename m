Return-Path: <linux-kernel-owner+w=401wt.eu-S969420AbXEIDz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969420AbXEIDz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbXEIDzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:55:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39765 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbXEIDzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:55:18 -0400
Message-ID: <4641461F.1030101@garzik.org>
Date: Tue, 08 May 2007 23:55:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
References: <46413851.6070505@zytor.com> <46413A7E.5050304@garzik.org> <alpine.LFD.0.98.0705082032591.4062@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705082032591.4062@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 8 May 2007, Jeff Garzik wrote:
>> I wonder if this fbdev update is what causes my X session to die?
> 
> Not that particular patch, but yeah, it could certainly be the fbdev 
> update.
> 
> Can you try bisecting it?

Planning to, but not tonight.

	Jeff



