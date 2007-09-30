Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbXI3BRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbXI3BRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 21:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXI3BRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 21:17:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:22456 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXI3BRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 21:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mj+jhnVrKPH2nqFwDqD+jj9wrFtwx5Hk4K7ClPDMyk4WbaqPS+wMSACzL9cBOVl0vkrW2OvamFXy+pr9fp8hnwqFqowMnoIWDowll8eWk53jGCZKevwx+5BKY37hySdgcrrpZiadyH2auosUPY2FcwHZ29KlAprKzudSWFnroOo=
Subject: Re: [PATCH] make unicode default
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bill Nottingham <notting@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709291034100.22032@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709291034100.22032@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Sun, 30 Sep 2007 09:17:11 +0800
Message-Id: <1191115031.10537.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-29 at 10:36 +0200, Jan Engelhardt wrote:
> Make the vt return to the system default when it is reset.
> Also make UTF-8 the system default.

It's about time we do, so this is fine with me.

Tony


