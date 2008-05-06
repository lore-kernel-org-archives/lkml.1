Return-Path: <linux-kernel-owner+w=401wt.eu-S934069AbYEFXMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069AbYEFXMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbYEFXM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:12:28 -0400
Received: from stinky.trash.net ([213.144.137.162]:44611 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYEFXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:12:27 -0400
Message-ID: <4820E5B7.3090503@trash.net>
Date: Wed, 07 May 2008 01:11:51 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: libata regression in current -git
References: <480D6A25.2040206@trash.net> <200805070035.59272.rjw@sisk.pl>
In-Reply-To: <200805070035.59272.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 22 of April 2008, Patrick McHardy wrote:
>   
>> I bisected a boot-failure with sata-sis back to this libata-change:
>>     
>
> Has the problem been fixed in 2.6.26-rc1 or in the current -git?
>   

Yes, both 2.6.26-rc1 and current -git work fine.


