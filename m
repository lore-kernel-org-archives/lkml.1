Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab0BEN2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:28:54 -0500
Received: from senator.holtmann.net ([87.106.208.187]:55274 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab0BEN2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:28:53 -0500
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report
 descriptor.
From: Marcel Holtmann <marcel@holtmann.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Michael Poole <mdpoole@troilus.org>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <1265374184.3117.22.camel@localhost.localdomain>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <871vh1gpaz.fsf_-_@troilus.org>
	 <1265374184.3117.22.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 05:27:51 -0800
Message-ID: <1265376471.31341.210.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bastien,

> > This patch works for me.  Bastien, does it also fix it for you?
> 
> Patch works great. Thanks for hunting it down.

now I only need a modified version as requested and I can push that one
upstream with all the other fixes from the UnPlugFest testing.

Regards

Marcel


