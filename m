Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbXFSO67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbXFSO67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXFSO6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:58:53 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51825 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbXFSO6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:58:52 -0400
Date: Tue, 19 Jun 2007 16:58:43 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
cc: linux-kernel@vger.kernel.org
Subject: Re: Error -71 on device descriptor read/all
In-Reply-To: <4677EBF8.5020104@mandic.com.br>
Message-ID: <Pine.LNX.4.64.0706191657050.3068@twin.jikos.cz>
References: <4677EBF8.5020104@mandic.com.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Renato S. Yamane wrote:

> I see this in dmesg:
> usb 1-1: device descriptor read/all, error -71
> Using 2.6.21.1
> Someone know what it is?

Is this a USB 2.0 high-speed device? Don't you for example have USB 
extension cable too long to work on-high speed?

I guess the situation improves when you force USB 1.1 (i.e. rmmod 
ehci_hcd), right?

-- 
Jiri Kosina
