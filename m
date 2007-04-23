Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbXDWQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbXDWQLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXDWQLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:11:40 -0400
Received: from sf01.pol.net ([63.240.86.10]:12285 "EHLO sf01.pol.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbXDWQLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:11:39 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 12:11:39 EDT
Message-ID: <64604.10.250.10.1.1177344350.squirrel@webmail.medscape.com>
Date: Tue, 24 Apr 2007 00:05:50 +0800 (PHT)
Subject: Re: Prevent softlockup triggering in nvidiafb
From: "Antonino A. Daplas" <adaplas@pol.net>
To: <davej@redhat.com>
In-Reply-To: <20070423151053.GA5653@redhat.com>
References: <20070423151053.GA5653@redhat.com>
X-Priority: 3
Importance: Normal
X-MSMail-Priority: Normal
Cc: <linux-kernel@vger.kernel.org>, <adaplas@pol.net>
Reply-To: adaplas@pol.net
X-Mailer: SquirrelMail (version 1.2.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If the chip locks up, we get into a long polling loop,
> where the softlockup detector kicks in.
> See https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=151878
> for an example.

Okay. Thanks.

>
> Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Tony



