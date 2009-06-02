Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbZFBLhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbZFBLhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbZFBLhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:37:03 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:43589 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbZFBLhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:37:01 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Seagate Barracuda 7200.11 ST31500341AS fw SD17
Date: Tue, 2 Jun 2009 13:37:02 +0200
User-Agent: KMail/1.9.10
References: <200906021258.20346.M4rkusXXL@web.de> <4A250B6A.6030904@grupopie.com>
In-Reply-To: <4A250B6A.6030904@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021337.03123.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1/fpsj0F1w0EFjhORCe3g+7tEqGZWXaLeXr9tXy
	FPel2O9L4pfE7eDW2mRH6IsBIL9gCKWPSLUuvoHjqmoHi0Mg5X
	V0KfjWitg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui Santos wrote:
>> I have some Seagate Barracuda 7200.11 ST31500341AS 1.5TB drives. They 
>> use the firmware SD17.
> Seagate recommends firmware SD1A for that HD.
> However, I do not know if it will solve your problem. Jut try it...

>> This drive+fw is blacklisted in the kernel, but there is no firmware 
>> upgrade for these drives. (Only very few serial numbers are able to 
>> upgrade.)

I cant upgrade the firmware because the flash-utility will abort due 
to "not affected serial number". I tried SD1B, the very newest version.
Cant find the SD1A for my drives.

Markus
