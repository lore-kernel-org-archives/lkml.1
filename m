Return-Path: <linux-kernel-owner+w=401wt.eu-S1751315AbXAXMXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbXAXMXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXAXMXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:23:34 -0500
Received: from mail1.key-systems.net ([81.3.43.211]:33801 "HELO
	mail1.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751315AbXAXMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:23:34 -0500
Message-ID: <45B74FC2.7090200@scientia.net>
Date: Wed, 24 Jan 2007 13:23:30 +0100
From: Christoph Anton Mitterer <calestyo@scientia.net>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange
References: <45B69D0C.8030501@scientia.net>	<20070124000905.3a7b053d@localhost.localdomain>	<45B6A1D4.7020906@scientia.net> <20070124011734.47a06a25@localhost.localdomain>
In-Reply-To: <20070124011734.47a06a25@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------050603010501070005080506"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050603010501070005080506
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Alan wrote:
>> I knew of course about libdvdcss but I've never noticed before that the
>> kernel issues these error messages to the syslog.
>>     
> Various bits of random desktop junk poll drives to see what has appeared
> and stick icons on desktops. Some of them do stuff that produces messages
> like this because they aren't careful how they probe and what they do.
>   
Yes of course, but I've disabled that end-user stuff, and for
convenience even tested the whole thing with runlevel 1 (single user).


>> So you say this is normal?! But the problem with ejecting isn't probably
>> normal.
>>     
> Eject is application controllable. Most movie players re-enable the
> button.
>   
Yes I knew,.. I just wondered because that worked even when no player
was started at all. But I found out that this must depend on GNOME,
because when mount + eject-button from single-user,.. the disc is not
ejected.
Anyway it is ejected (+unmounted) when using the eject command (but I
assume that this is normal).

Thanks,
Chris.

--------------050603010501070005080506
Content-Type: text/x-vcard; charset=utf-8;
 name="calestyo.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="calestyo.vcf"

YmVnaW46dmNhcmQNCmZuOk1pdHRlcmVyLCBDaHJpc3RvcGggQW50b24NCm46TWl0dGVyZXI7
Q2hyaXN0b3BoIEFudG9uDQplbWFpbDtpbnRlcm5ldDpjYWxlc3R5b0BzY2llbnRpYS5uZXQN
CngtbW96aWxsYS1odG1sOlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------050603010501070005080506--
