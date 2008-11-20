Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYKTAmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYKTAmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYKTAl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:41:56 -0500
Received: from main.gmane.org ([80.91.229.2]:34241 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYKTAl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:41:56 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Compiler warnings
Date: Wed, 19 Nov 2008 18:41:42 -0600
Message-ID: <4924B246.1010508@shaw.ca>
References: <f188924b0811190816g2301b38ap814f64824055cd59@mail.gmail.com> <20081119162331.5421a67b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: "Fred ." <eldmannen@gmail.com>
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <20081119162331.5421a67b@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 19 Nov 2008 17:16:14 +0100
> "Fred ." <eldmannen@gmail.com> wrote:
> 
>> I compiled the Linux 2.6.27.6 kernel on Ubuntu 8.10 with gcc (Ubuntu
>> 4.3.2-1ubuntu11) 4.3.2.
> 
> Your compiler appears to be faulty. You should report this to Ubuntu
> 
The warnings are valid (they're coming from -Wformat-security) but I 
don't believe those warnings are normally enabled in kernel compilation. 
Presumably some Ubuntu gcc patch enables them by default.

