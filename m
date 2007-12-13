Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbXLMBFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbXLMBFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 20:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXLMBFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 20:05:05 -0500
Received: from mail44.messagelabs.com ([216.82.249.179]:13840 "HELO
	mail44.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752013AbXLMBFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 20:05:04 -0500
X-VirusChecked: Checked
X-Env-Sender: arasv@magtech.com.au
X-Msg-Ref: server-2.tower-44.messagelabs.com!1197507901!508894!1
X-StarScan-Version: 5.5.12.14.2; banners=magtech.com.au,-,-
X-Originating-IP: [150.101.126.166]
Message-ID: <47608538.6030301@magtech.com.au>
Date: Thu, 13 Dec 2007 12:04:56 +1100
From: Aras Vaichas <arasv@magtech.com.au>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: mmaping an IO port device
References: <4760727E.2090906@magtech.com.au>
In-Reply-To: <4760727E.2090906@magtech.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aras Vaichas wrote:
> Hi,
>
> Can I implement mmap with an io port connected device on an x86 based 
> CPU?
>
I'll just add one more bit of information which might effect the 
situation. The CPU I am using is an Elan SC520 microcontroller.

It seems that this CPU is able remap the General Purpose ports (IO 
ports) into the lower 1GB of memory space.

I will investigate.

If anyone knows anything about doing this, please speak up. This is a 
legacy CPU in our product range, and I don't have much experience with it.

Aras


______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
