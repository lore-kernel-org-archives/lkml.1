Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbZL3L1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbZL3L1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZL3L1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:27:24 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:49495 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751522AbZL3L1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:27:23 -0500
Message-ID: <4B3B3905.4050200@ru.mvista.com>
Date: Wed, 30 Dec 2009 14:27:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: me@felipebalbi.com
Cc: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers/usb/core/sysfs.c:201 unused variable 'value'
References: <4B3A9589.6060201@googlemail.com> <1262131313.28789.134.camel@gandalf>
In-Reply-To: <1262131313.28789.134.camel@gandalf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Felipe Balbi wrote:

>> The variable 'value' is unused in 'set_reset_quirk()'.
>>
>> Greetings René Bolldorf
>>     
>
> I already sent a patch for that [1]
>
> [1] http://marc.info/?l=linux-usb&m=126203765207545&w=2
>   

   And you weren't the first one:

http://marc.info/?l=linux-usb&m=126165643307894


WBR, Sergei


