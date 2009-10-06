Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbZJFUHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbZJFUHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932729AbZJFUG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:06:59 -0400
Received: from rtr.ca ([76.10.145.34]:58046 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbZJFUG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:06:59 -0400
Message-ID: <4ACBA33C.7090606@rtr.ca>
Date: Tue, 06 Oct 2009 16:06:20 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bernie Innocenti <bernie@codewiz.org>
Cc: Harri Olin <harri.olin@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>
In-Reply-To: <1254852272.1471.172.camel@giskard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you could also send me the output of "lspci -vv" for the cards
then I can also have a quick look at chipset errata for possibilities.

The early revs of these chips did have a number of errata specific to PCI-X.

Cheers
