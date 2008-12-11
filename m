Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYLKAZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYLKAZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYLKAZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:25:27 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:63968 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYLKAZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x70g7LjqfSVao4ddXwfEF4s0BNdgcFBaBfWiXk258HrdV2DdtlGOM+W+MCqNszwE0F
         7CJQxE3KaGnoR3uBq12v0Hul13AhllSQyEiJaSaRSgCkkufOaUNlTOqnBw+tIRxDZQj8
         0eoK04ldVx2W7P2fZoXQrr4Gij2Dh63/aNdS4=
Message-ID: <ef37ea20812101625u38af0b42q6a23246bc3eb803@mail.gmail.com>
Date: Thu, 11 Dec 2008 00:25:24 +0000
From: "Task Struct From Hell" <taskstructfromhell@googlemail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: linux rebooting w/o crash dump
In-Reply-To: <ef37ea20812101623g52a36179g7924683d492e7fa7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ef37ea20812101623g52a36179g7924683d492e7fa7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way to debug a kernel that shuts down without leaving any
sign of crash, shutdown demand or anything else?

I am absolutely sure it's not a power issue, as I am running
multi-boot and it's never shutting down on my other OSes, plus, with a
newer kernel everything works like a charm - even with the flag
'noreboot'. I would seriously love to find the root of this problem,
but I'm feeling slightly hand-tied on it, been seeking for hints and
trying different configurations for about 2 weeks...

Thanks in advance.
