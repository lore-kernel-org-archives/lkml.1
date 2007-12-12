Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbXLLVZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbXLLVZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXLLVZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:25:15 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37340 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXLLVZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:25:13 -0500
Message-ID: <476051B0.40007@davidnewall.com>
Date: Thu, 13 Dec 2007 07:55:04 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Chris Holvenstot <cholvenstot@comcast.net>
Subject: Re: [RESULTS] Port 0x80 I/O speed
References: <47603327.6070307@keyaccess.nl> <Pine.LNX.4.61.0712121459570.6100@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0712121459570.6100@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
> But there are some things that get set up long before
> udelay() is calibrated! The interrupt controllers,
> the timer, etc. You can't just substitute or you
> will end up with machines that won't boot!
>   

The initial value could be set conservatively high.
