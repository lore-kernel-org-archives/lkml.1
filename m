Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXKYSgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXKYSgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 13:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXKYSgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 13:36:45 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45478 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbXKYSgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 13:36:45 -0500
Date: Sun, 25 Nov 2007 12:36:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: forcedeth ethernet driver & Low power state
In-reply-to: <fa.XqgRE47bF/VjxtMudX1m05vea0g@ifi.uio.no>
To: Jeroen <j.geusebroek@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4749C0B5.3010309@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.XqgRE47bF/VjxtMudX1m05vea0g@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen wrote:
> Hi,
> 
> I'm migrating my server from windows 2003 server to Ubuntu, but I am
> stumbling over the "Low Power State Link Speed" option for my NIC
> (forcedeth)
> 
> I need to disable this option in my windows driver otherwise the trough pout is
> horrible because the link fluctuates constantly from 100/1000.
> 
> Anyway, my question is where and how can I turn off this feature for the
> forcedeth driver? I've looked in the source and as far as I can tell there is no
> bootoption for this. There are some references noted in the code, but AFAIK
> no setting.
> 
> Any ideas? Thanks in advance!

Are you sure forcedeth even supports that feature? I haven't seen any 
code for it, and certainly it should never be enabled by default..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

