Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbYLWJHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbYLWJHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 04:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYLWJGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 04:06:52 -0500
Received: from usul.saidi.cx ([204.11.33.34]:40735 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753202AbYLWJGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 04:06:51 -0500
Message-ID: <4950AA1F.6080506@overt.org>
Date: Tue, 23 Dec 2008 01:06:39 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: "Robert M. Albrecht" <linux@romal.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug 10173 / Bluetooth on Toshiba & Compal laptops
References: <4946BE11.5080501@romal.de> <bbd413efc08484efe55c558e9a0980fb@localhost> <4946DB8C.5000308@romal.de> <5a670e0fe13a5f433ef207efefd71ca2@localhost> <49508D8B.20801@romal.de>
In-Reply-To: <49508D8B.20801@romal.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert M. Albrecht wrote:
> Hi,
> 
> the module is loaded:
> 
> [root@tycho ~]# lsmod | grep kill
> rfkill                 11288  2 toshiba_acpi
> [root@tycho ~]#
> 
> The wlan-devices works ok, it get's disabled and enabled via rfkill. But 
> the bluetooth-device does not get reeanbled after switching it off.

Umm. I'll quote you quoting me.

> 
> Am 15.12.2008 23:47 Uhr, schrieb Philip Langdale:
>>
>> If you don't load the 'rfkill-input' module, then there is no policy
>> applied to killswitch handling.

--phil
