Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYLWGcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYLWGcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 01:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYLWGcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 01:32:31 -0500
Received: from mail.bigtelecom.ru ([87.255.0.61]:36800 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYLWGcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 01:32:31 -0500
Message-ID: <495085F9.5090805@bigtelecom.ru>
Date: Tue, 23 Dec 2008 09:32:25 +0300
From: Badalian Vyacheslav <slavon@bigtelecom.ru>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Red leds at harddisk bays on SR1530HSH after update to 2.6.27.x
References: <494A34CA.9030906@bigtelecom.ru> <20081219223246.b0aea84d.akpm@linux-foundation.org> <494EF9A1.90002@kernel.org>
In-Reply-To: <494EF9A1.90002@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo пишет:
> Andrew Morton wrote:
>   
>> (cc linux-ide)
>>
>> On Thu, 18 Dec 2008 14:32:26 +0300 Badalian Vyacheslav <slavon@bigtelecom.ru> wrote:
>>
>>     
>>> Hello all.
>>> After update from 2.6.26 to 2.6.27 all leds at drive bays now red.
>>> SATA controller in AHCI mode.
>>> Platform is Intel SR1530HSH
>>>
>>> Config attached.
>>>
>>> Any patches for test? Any ideas? Any other info needed? Or i must go to
>>> bugtracker? ;)
>>>       
>
> Does ahci.ahci_em_messages=0 help?
>
>   
All leds turned off. No green led at bay with hard disk.
