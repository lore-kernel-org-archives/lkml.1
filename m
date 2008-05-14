Return-Path: <linux-kernel-owner+w=401wt.eu-S1763593AbYENPWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763593AbYENPWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYENPWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:22:44 -0400
Received: from mailer2.option.com ([81.246.70.163]:16867 "EHLO
	mailer2.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYENPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:22:44 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 11:22:43 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUAAB6eKkgKAAAZ/2dsb2JhbAAIrgQ
Message-ID: <482B016E.2080306@option.com>
Date: Wed, 14 May 2008 17:12:46 +0200
From: Filip Aben <f.aben@option.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
CC: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: HSO: add option hso driver
References: <20080513215134.GC6139@kroah.com> <20080513232727.21c74bb2@core> <482A23B8.7050705@pobox.com> <20080514015815.GA29785@kroah.com> <20080514045712.GA2843@kroah.com> <482AF058.3020505@teltonika.lt>
In-Reply-To: <482AF058.3020505@teltonika.lt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2008 15:12:46.0094 (UTC) FILETIME=[F6F402E0:01C8B5D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulius Zaleckas schreef:
> Greg Kroah-Hartman wrote:
>> +#define DRIVER_VERSION            "1.2"
> 
> Maybe we should bump the version?
> Now it is the same as the different driver at PHARscape.

Probably the best thing would be to drop it altogether as it doesn't 
make a lot of sense to maintain it in the kernel. Also the pharscape 
version will continue to live it's own life till the hso driver is fully 
settled in an official kernel, so version conflicts would be bound to 
happen anyway.

Regards,

Filip-

