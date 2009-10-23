Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbZJWClD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbZJWClD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 22:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZJWClB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 22:41:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53970 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZJWClA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 22:41:00 -0400
Message-ID: <4AE117B3.3040807@canonical.com>
Date: Fri, 23 Oct 2009 10:40:51 +0800
From: Bryan Wu <bryan.wu@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <matthias@urlichs.de>
CC: smurf@smurf.noris.de, linux-usb@vger.kernel.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UBUNTU: USB: option: TLAYTECH TUE800 support
References: <1256194836-15733-1-git-send-email-bryan.wu@canonical.com> <1256202285.7526.109.camel@kiste>
In-Reply-To: <1256202285.7526.109.camel@kiste>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Urlichs wrote:
> On Thu, 2009-10-22 at 15:00 +0800, Bryan Wu wrote:
>> Add ID for Tlaytech TUE800 CDMA modem to the option driver.
>>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> Acked-By: Matthias Urlichs <matthias@urlichs.de>
> 
> 

Thanks a lot, Matthias. Do you think we need to include this patch into 31.y stable release?
Since our 9.10 Ubuntu kernel is based on .31 kernel, we need to include this patch through stable 
release.

-Bryan

