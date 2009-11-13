Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbZKMX2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbZKMX2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbZKMX16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:27:58 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38797 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbZKMX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:27:58 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alexander Holler <holler@ahsoftware.de>, linux-usb@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
Date: Sat, 14 Nov 2009 00:30:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4AFDDDF6.4050907@ahsoftware.de>
In-Reply-To: <4AFDDDF6.4050907@ahsoftware.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911140030.32727.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 13. November 2009 23:30:14 schrieb Alexander Holler:
> (And here comes the problem)
> 
> Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed 
> USB device using ehci_hcd and address 3
> Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware 
> changed

You cut too early. This shows a failed reset but not the cause.

	Regards
		Oliver
