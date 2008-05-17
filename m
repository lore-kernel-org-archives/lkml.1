Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYEQPKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYEQPKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYEQPKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:10:35 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:58801 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754979AbYEQPKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:10:34 -0400
X-Greylist: delayed 77529 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 11:10:34 EDT
X-Originating-IP: [70.152.106.225]
Date: Sat, 17 May 2008 10:10:26 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080517101026.270a6f4e@osprey.hogchain.net>
In-Reply-To: <543631.10570.qm@web52902.mail.re2.yahoo.com>
References: <20080517082207.4b1e8556@osprey.hogchain.net>
	<543631.10570.qm@web52902.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 15:49:08 +0100 (BST)
Chris Rankin <rankincj@yahoo.com> wrote:

> Does yours still work if you raise the baud rate to 115200? 

No, but I also get garbage characters and a generally unusable logging
device.  57600 is slightly better, but not much.  I remember going
through this progressive reduction in baud rate a long time ago,
trying to find a speed that works reliably, which is why I settled on
38400. I get unpredictable results for anything higher.
