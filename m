Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329Ab0AVPLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0AVPLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282Ab0AVPLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:11:33 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53249 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab0AVPLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:11:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cCbApbpKrvahGEb2u+NDPvqaHOGhFHa6FSALiIasdwzNsw7AKrSysbE1RbikvQbOd+
         5PhFowwWi2Fbv0dwy1P3+RsqGy5MYLpEIDhMCU6d54qGPu1p3t9FmXRpV3KlRPrq1AKC
         7WQkGWhaLuPASFfVFM0tFyvBle6pn9CP+jV/k=
Message-ID: <4B59C01E.90804@gmail.com>
Date: Fri, 22 Jan 2010 16:11:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, add IR support for digivox
 mini II
References: <1263412807-23350-1-git-send-email-jslaby@suse.cz> <4B4F6BE5.2040102@iki.fi>
In-Reply-To: <4B4F6BE5.2040102@iki.fi>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 08:09 PM, Antti Palosaari wrote:
> Device ID 15a4:9016 is reference design ID and it is used by vary many
> devices. Also manufacturer string "Afatech" is chipset default one. This
> leads MSI remote in question configured for many devices using default /
> reference values which I don't like good idea. Strings and other USB
> settings are stored to the device eeprom.

What do you think about the following patches?

thanks,
-- 
js
