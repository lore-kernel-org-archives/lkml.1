Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0BUKHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 05:07:31 -0500
Received: from senator.holtmann.net ([87.106.208.187]:43304 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0BUKH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 05:07:28 -0500
Subject: Re: [PATCH 1/2] Document the rfkill sysfs ABI
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: florian@mickler.org, linux-wireless@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
	 <1266702045-6062-2-git-send-email-florian@mickler.org>
	 <1266704345.32739.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Feb 2010 11:08:50 +0100
Message-ID: <1266746930.18491.1.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> > This moves sysfs ABI info from Documentation/rfkill.txt to the
> > ABI subfolder and reformats it.
> > 
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> 
> This is fine with me.

we have to be careful here. Some of these sysfs details needs to be
deprecated and removed. Applications should use /dev/rfkill actually.

Regards

Marcel


