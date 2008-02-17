Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYBQUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYBQUh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYBQUhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:37:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:34150 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYBQUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:37:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ng8o/FFGXTerZXDvHOs5fVjzNAIfDCcb5S+rPO4Lfay5vAsnW1V4q9u5yDlfSaW4nGHU7b9k8+4dLFO6TV+O9LIuyZj9Ftp2B3Vu5UjCBsABw7xC1xy8OQorW91HLiUF4pWSISXah9Zrt1Wqs5tmS/ovhyGdBBDVd/1GfV6fEn4=
Message-ID: <47B89AF3.9040102@gmail.com>
Date: Sun, 17 Feb 2008 21:37:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>
CC: linux-kernel@vger.kernel.org
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20
 to 2.6.24.2
References: <47B892B9.7060205@allied-internet.ag>
In-Reply-To: <47B892B9.7060205@allied-internet.ag>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2008 09:02 PM, allied internet ag- Stefan Priebe wrote:
> Hello!
> 
> One week ago we upgraded about 300 servers from 2.6.20.20 to 2.6.24.2.

Painfull.

> Now we get sometimes dozent of processes in state DN. The system is 
> completely idle - but the load is 20 or 90 or whatever. And it can only 
> be "repaired" by rebooting the system.

please post sysrq-t (echo t > /proc/sysrq-trigger) output.

> I'm NOT on the LIST so please CC me.

We ever do...
