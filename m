Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYAVMcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYAVMcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYAVMcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:32:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:40209 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYAVMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JAmMw9F/wrsXJTifgiWk6GdiCwCoGKnUU//35j10TMo5nglmNm+W5eA6+8mCK1M8uGAyXtm0/p5PSMujGLPChc4Gwv4gxEmiM9+/SaUzH/dsOhXwVXpfSPT8hp4R9K834cp4MGCCPQdm7TXbbwKMOqK0Mzxi9Eh7IrGfy58HkWk=
Message-ID: <4795E23A.1010306@gmail.com>
Date: Tue, 22 Jan 2008 13:31:54 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?IkouIFBhYmxvIEZlcm7DoW5kZXoi?= <pupeno@pupeno.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Making a USB driver
References: <fn2u8p$gv3$1@ger.gmane.org> <479515FF.3050705@gmail.com> <200801212313.17703.pupeno@pupeno.com> <479527C7.5000909@gmail.com> <fn4bgk$oi0$1@ger.gmane.org> <4795B506.1030405@gmail.com> <fn4l7p$ncc$1@ger.gmane.org>
In-Reply-To: <fn4l7p$ncc$1@ger.gmane.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2008 12:49 PM, J. Pablo Fernández wrote:
>> On 01/22/2008 10:03 AM, J. Pablo Fernández wrote:
>>> Jiri Slaby wrote:
>> Ask for specification, otherwise you won't be able to write a driver
>> anyway.
> 
> They already told me they don't even have the specification. 

Maybe they might provide you some pieces of win code :P?

> I'm already
> considering doing reverse engineering to get the information. It won't be
> easy for me because I'm new to this level, but it shouldn't be very hard,
> it's not a scanner or a webcam, it should be a fairly simple protocol.

Ok, then you need the device anyway :). After you got it, you might get the usb ids.
