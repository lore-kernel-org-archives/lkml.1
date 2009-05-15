Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbZEOWRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbZEOWRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZEOWRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:17:10 -0400
Received: from fmailhost05.isp.att.net ([204.127.217.105]:57223 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZEOWRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:17:09 -0400
X-Originating-IP: [71.195.50.4]
Message-ID: <4A0DE9CC.5050109@lwfinger.net>
Date: Fri, 15 May 2009 17:16:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Johannes Berg <johannes@sipsolutions.net>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression since 2.6.30-rc1 - Page allocation failures
References: <49F8C03D.6040909@lwfinger.net> <1241040451.5067.0.camel@johannes.local> <49F8E145.1050708@lwfinger.net> <200905152349.47940.rjw@sisk.pl>
In-Reply-To: <200905152349.47940.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>
>> kernel: phy0: failed to reallocate TX buffer 0, 404, need 0, 0
>> kernel: protocol 0008 is buggy, dev eth1
>>
>> kernel: phy0: failed to reallocate TX buffer 0, 1728, need 0, 18
>>
>> Device eth1 is the b43 wireless device.
> 
> Can you please tell me what the status of this bug is?

I have not had the opportunity to trace this bug.

