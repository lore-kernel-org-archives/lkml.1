Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0CDAVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:21:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52571 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0CDAU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:20:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FyFk4cxXSgnnilxflbFevxwcjH7c6do5RWq6gw4g8hu131j8hm887EAio4gZ679AcN
         G4fhDYpXLIQ3vcOLmrktDeYUAlTkvrBrTIKk3/5nxCqophYMRpgOuv9vEdeU2OeSwSaV
         QiPxTsxKit26mzX1KclaFzFJeaUko29ANeqE4=
MIME-Version: 1.0
In-Reply-To: <9debc4411003030709r597d4f6dmeacadce5c3cf2ed7@mail.gmail.com>
References: <1267506354.1618.4.camel@virtubuntu> <201003021451.59773.arnd@arndb.de> 
	<9debc4411003030709r597d4f6dmeacadce5c3cf2ed7@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 3 Mar 2010 19:20:37 -0500
Message-ID: <8bd0f97a1003031620s44cff658x81fc36fa2a8efd96@mail.gmail.com>
Subject: Re: yaffs2 NAND fs
To: Maxin John <maxin.john@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Paul <abnominales@web.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 10:09, Maxin John wrote:
> On Tue, Mar 2, 2010 at 7:21 PM, Arnd Bergmann wrote:
>> On Tuesday 02 March 2010, Peter Paul wrote:
>>> I was wondering why the yaffs2 file system has not gone for mainline
>>> yet. It's rather popular flash file system in the embedded world, while
>>> it is rather easy to patch a kernel to have yaffs2 support [1] it would
>>> be even nicer if it was just in mainline.
>>> The source of the GPLv2 file system can be found at [2]
>>>
>>> [1] http://www.yaffs.net/howto-incorporate-yaffs
>>> [2] http://www.aleph1.co.uk/cgi-bin/viewcvs.cgi/yaffs2/
>>
>> I would guess it's a combination of multiple reasons:
>>
>> 1. It has not been submitted for upstream inclusion, at least not
>>   during the last few years.
>> 2. We don't have a staging area like drivers/staging for file systems
>>   in the way that we have for drivers
>> 3. There is now ubifs and (soon) logfs upstream, both of which appear
>>   to be superior to yaffs in many ways.
>
> This means there should be no reference to YAFFS2 in the upstream
> kernel? Because, I have located some defconfigs in upstream kernel
> where YAFFS2 support is enabled by default.

irrelevant noise
-mike
