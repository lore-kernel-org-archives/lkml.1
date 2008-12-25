Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbYLYBIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbYLYBIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 20:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLYBIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 20:08:09 -0500
Received: from main.gmane.org ([80.91.229.2]:43065 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYLYBII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 20:08:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Sil 3132 SATA II express card
Date: Wed, 24 Dec 2008 19:07:58 -0600
Message-ID: <4952DCEE.5050900@shaw.ca>
References: <49528352.9000906@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <49528352.9000906@asyr.hopto.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis wrote:
> I have compiled in kernel (2.6.27) support for Sil 3132:
> CONFIG_SATA_SIL24=y
> 
> When I insert the card in the laptop's slot, dmesg shows nothing new.
> Is this normal?
> 

You should get some messages at the very least. Do you have the proper 
hotplug support compiled into your kernel? Do any ExpressCards work?

