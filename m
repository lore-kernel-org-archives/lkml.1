Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0BEMuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:50:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab0BEMuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:50:03 -0500
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report
 descriptor.
From: Bastien Nocera <hadess@hadess.net>
To: Michael Poole <mdpoole@troilus.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <871vh1gpaz.fsf_-_@troilus.org>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <871vh1gpaz.fsf_-_@troilus.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 05 Feb 2010 12:49:44 +0000
Message-ID: <1265374184.3117.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 07:26 -0500, Michael Poole wrote:
> Bastien and Marcel,
> 
> This patch works for me.  Bastien, does it also fix it for you?

Patch works great. Thanks for hunting it down.

