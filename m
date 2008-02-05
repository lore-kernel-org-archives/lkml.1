Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbYBEWeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbYBEWeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYBEWdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:33:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:8846 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761754AbYBEWdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:33:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nHS2DbPLvps57lUn5UedID7z0scNx1jhUBG2Gge/XGnRISqNHxUMSKK89vpd6L7soWRptcXVWfkO806W69p9VRtj9I1ZRDaUF37I2Sr//5gMbmL8f/wPNFPu3LkiVRb9pnnL2VQ+BnhHQqvf7NXieOF8dZts+JrlqmDdnopctZ0=
Message-ID: <47A8E44A.6090003@gmail.com>
Date: Tue, 05 Feb 2008 23:33:46 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Rick Warner <rick@microway.com>, linux-kernel@vger.kernel.org
Subject: Re: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout"
 patch
References: <200802051402.26816.rick@microway.com> <47A8C4AB.3030301@microgate.com> <47A8CCC0.8020703@microgate.com> <200802051632.54058.rick@microway.com> <47A8D71F.4050601@microgate.com> <47A8DC2B.20604@gmail.com> <47A8E2D5.6010503@microgate.com>
In-Reply-To: <47A8E2D5.6010503@microgate.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2008 11:27 PM, Paul Fulghum wrote:
> Jiri Slaby wrote:
>> It should be fixed already as of
>> git-describe db99247a
>> v2.6.24-rc6-95-gdb99247
>>
>> So since 2.6.24-rc7.
>>
>> Maybe we should consider the fix for 2.6.23 too.
> 
> Whoops, I missed that.
> Problem solved :-)

:) Thank you both for heads up.
