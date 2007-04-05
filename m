Return-Path: <linux-kernel-owner+w=401wt.eu-S1767188AbXDESRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767188AbXDESRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767190AbXDESRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:17:30 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:51589 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767188AbXDESR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:17:29 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 14:17:29 EDT
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=booyaka.com;
  b=eRYCrb5MTPBMWoVOMQwDaPGwvR7v2YO3sss2sTMdhGf7c0J5LTJJdXo40ripn69beBCpPqGCtmE7hBeoAbN4nMq0thpUn6tVq2UdkvOOLNJe+2Q/IS/AZxJE+DMkOpNOS6kegBnveJfWa/1bSaat0pnUDeXP/JuExcVFkZS9Qp/xdsLloasr2LApu2zr9cWQTw0byRaHpJYqfK7oiYiRKNuUDeJE1Xm2KkNKQSi/d+lGQuQxKQ/fsVpcKuv7bzi4ipAvp83Cx4d/ik0GIRN9kvrN6fupFXbnFJie7xdaGJexuD811faFyuio/qRlRwaNtyoE1WRIlAPe4iiarNxKEg==  ;
Date: Thu, 5 Apr 2007 12:10:47 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Jiri Kosina <jkosina@suse.cz>
cc: Li Yu <raise.sail@gmail.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <Pine.LNX.4.64.0704031058240.3808@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0704051209570.7748@utopia.booyaka.com>
References: <56464.192.54.193.51.1175515024.squirrel@rousalka.dyndns.org>
 <4611B0A1.8070106@gmail.com> <Pine.LNX.4.64.0704031058240.3808@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Jiri Kosina wrote:

> On Tue, 3 Apr 2007, Li Yu wrote:
>
>> May be, we need some means to change blacklist in runtime.
>
> Paul Walmsley (added to CC) sent me patches some time ago that among other
> things implemented possibility to modify the hid_blacklist[] in runtime.
> The patches had some issues which Paul said will fix - Paul, what is the
> current status please?

Hi Jiri,

I'll finish fixing those up and will send them to linux-input@ by the end 
of the week.


- Paul
