Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbZDKWo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbZDKWo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 18:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbZDKWoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 18:44:46 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:53910 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759050AbZDKWop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 18:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xNyNxXVn9SVOOpLF07IvTa3Tdjyew1WpxfHOLzkdTd9E1GANXz1jf/bqqqT3D2bG8j
         NfzPC7ybZ5N7LMlrC4bIvPflwsaN6dBg1BIuw2GjqVqoqkKmTMLS0NiG12sdxZpKnl91
         /6ohvNqqUYEZ3f2nOplawPi2s58Cmb/aycHRg=
Message-ID: <49E11D6B.3000001@gmail.com>
Date: Sun, 12 Apr 2009 00:44:59 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness
 with hotkeys
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org>
In-Reply-To: <20090411150555.8b13ed18.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2009 12:05 AM, Andrew Morton wrote:
> (cc's added)
>
> On Sat, 11 Apr 2009 23:07:16 +0200 Niel Lambrechts <niel.lambrechts@gmail.com> wrote:
>
>   
>> Hi there,
>>
>> With latest git kernel, I'm no longer able to control my Thinkpad (W500)
>> brightness, although I can still control the backlight, bluetooth etc.
>>     
>
> So 2.6.29 was OK
Hi Andrew,

Yes - I quickly rebooted to 2.6.29.1, and it is working fine there ...

So these results are with both kernels using:
options thinkpad_acpi experimental=1

Thanks,
Niel
