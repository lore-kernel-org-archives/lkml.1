Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbXCDQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbXCDQsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbXCDQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:48:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:58239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbXCDQsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:48:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BJiIloeRRJaSmxn52rTDstj+aCCwXDrReCZ4TofrPjgzSBIUfUBcajo54UnGiwFC3a8n1J1Tsu7cSuYNGJjStTrDHsUiVpf+oCPMX3CnAL0YtBGEZpW2386Rig1nQvF8OFgn69Y4oAlwAoipDoHH21UvTUACcw6kximzcxmBb2U=
Message-ID: <8d158e1f0703040848l48064204pe5f994ba4663cd0c@mail.gmail.com>
Date: Sun, 4 Mar 2007 16:48:08 +0000
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [IPW3945] Can't load microcode
In-Reply-To: <8d158e1f0703040841m634b37d4r9f2d4135f5f4dfd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0703040841m634b37d4r9f2d4135f5f4dfd6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> Hi,
>
> I just downloaded the latest kernel drivers, daemon and microcode for
> my Intel Wireless card. everything built correctly, the microcode is
> placed in /lib/firmware and when running /etc/init.d/ipw3945d-start I
> get the following dmesg

Extra info:

When doing a /sbin/ipw3945d --kill && /sbin/ipw3945d I get:
ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
ipw3945: uCode verification failed at addr 0x00003800+0 (of 2396)
ipw3945: Unable to load firmware: -5
ipw3945: MAC is in deep sleep!
ipw3945: Unable to load firmware: -5
ipw3945: MAC is in deep sleep!
ipw3945: Unable to load firmware: -5
ipw3945: MAC is in deep sleep!
ipw3945: Unable to load firmware: -5
ipw3945: MAC is in deep sleep!
ipw3945: Unable to load firmware: -5
ipw3945: MAC is in deep sleep!
ipw3945: MAC is in deep sleep!
ipw3945: MAC is in deep sleep!
ipw3945: MAC is in deep sleep!
ipw3945: Unable to initialize device after 5 attempts.
ipw3945: MAC is in deep sleep!
ipw3945: Unable to int nic
ipw3945: MAC is in deep sleep!
ipw3945: Unable to int nic
ipw3945: MAC is in deep sleep!
ipw3945: Unable to int nic
ipw3945: MAC is in deep sleep!
ipw3945: Unable to int nic
ipw3945: MAC is in deep sleep!
ipw3945: Unable to int nic
ipw3945: MAC is in deep sleep!
ipw3945: Unable to int nic
