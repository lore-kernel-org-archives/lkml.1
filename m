Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbZJXSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbZJXSUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZJXSUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 14:20:32 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:42935 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZJXSUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 14:20:31 -0400
Message-ID: <4AE3456D.5000203@iki.fi>
Date: Sat, 24 Oct 2009 21:20:29 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Gonsolo <gonsolo@gmail.com>, mchehab@infradead.org, pboettcher@dibcom.fr,
       linux-media@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: DVB-T dib0700 one minute hang when resuming
References: <4AE32EF2.2040508@googlemail.com> <200910242014.18785.oliver@neukum.org>
In-Reply-To: <200910242014.18785.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 212.50.133.141
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2009 09:14 PM, Oliver Neukum wrote:
> Am Samstag, 24. Oktober 2009 18:44:34 schrieb Gonsolo:
>> Hi!
>>
>> The following script fixes an annoying 62 second hang when resuming
>> while my Nova-T stick is connected to my notebook.
>>
> Do you have any idea why it doesn't find its firmware?

Known issue. I have no idea where to start look from.
http://www.mail-archive.com/linux-media@vger.kernel.org/msg09974.html

Antti
-- 
http://palosaari.fi/
