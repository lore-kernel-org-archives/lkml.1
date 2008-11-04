Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYKDPQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYKDPQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYKDPQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:16:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:37814 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYKDPQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hN0cDfA9armBy3anUzzZf5zJJYLcXxw4JfMzNuCGkYzo8t4eCu2UEOOHHTWaZ87igE
         OYG0NssL0EhLwwCD2oD0whXUpA+WjGVYfm37iJu9JVlsuYqW+TBx4qminvO7ic4dwUbr
         FC+9t89Vgkh3J+xsTdWy1cfbBItK8JSL77V2o=
Message-ID: <49106747.8060709@gmail.com>
Date: Tue, 04 Nov 2008 16:16:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Add support for the new unibody macbooks
References: <49103CFA.1010707@euromail.se>
In-Reply-To: <49103CFA.1010707@euromail.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg napsal(a):
> The unibody MacBook 5 and MacBook Pro 5 come with a new version of
> the bcm5974 trackpad. This patch adds the USB device ids and the
> appropriate quirks.

Hi, thanks for the patch, but you omitted hid_blacklist addition.

Jiri K. (HID maintainer) is out for a while, expect longer rtt ;).
