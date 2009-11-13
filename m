Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbZKMXfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbZKMXfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932546AbZKMXfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:35:40 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:38171 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbZKMXfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:35:39 -0500
Message-ID: <4AFDED47.5070606@ahsoftware.de>
Date: Sat, 14 Nov 2009 00:35:35 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de> <200911140030.32727.oliver@neukum.org>
In-Reply-To: <200911140030.32727.oliver@neukum.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.11.2009 00:30, schrieb Oliver Neukum:
> Am Freitag, 13. November 2009 23:30:14 schrieb Alexander Holler:
>> (And here comes the problem)
>>
>> Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed
>> USB device using ehci_hcd and address 3
>> Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware
>> changed
>
> You cut too early. This shows a failed reset but not the cause.

There are no relevant messages in the log before:

--------
  Nov 13 19:06:23 krabat kernel: [  190.790549] EXT4-fs (dm-1): mounted 
filesystem with ordered data mode
Nov 13 19:08:05 krabat ntpd[3381]: synchronized to 192.168.207.1, 
stratum 2
Nov 13 19:08:05 krabat ntpd[3381]: kernel time sync status change 2001 

Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed 
USB device using ehci_hcd and address 3
----------------------------------------------------
