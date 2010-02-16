Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab0BPWNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:13:15 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:35474 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440Ab0BPWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:13:14 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Jan Sechser <jsechser@gmx.ch>
Subject: Re: Sony Ericson w995 does not local net mode
Date: Tue, 16 Feb 2010 23:13:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <4B7ACB75.4070907@gmx.ch>
In-Reply-To: <4B7ACB75.4070907@gmx.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002162313.15353.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Februar 2010 17:44:37 schrieb Jan Sechser:
> Other OS         (E.g. Mac(tm), Linux(tm))
>   usb 1-4: New USB device found, idVendor=0fce, idProduct=d112
>   usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>   usb 1-4: Product: Sony Ericsson W995
>   usb 1-4: Manufacturer: Sony Ericsson
>   usb 1-4: SerialNumber: 3582180356368990
>   usb 1-4: configuration #1 chosen from 1 choice

this is not enough to tell what's going on. Please send a full "lsusb -v"

	Regards
		Oliver
