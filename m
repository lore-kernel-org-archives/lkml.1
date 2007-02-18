Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbXBRXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbXBRXL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXBRXL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:11:27 -0500
Received: from fencepost.gnu.org ([199.232.76.164]:33855 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXBRXL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:11:26 -0500
Subject: Re: PCMCIA WLAN card initialization error
From: Pavel Roskin <proski@gnu.org>
To: Timur Aydin <ta@taydin.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87bqjr401n.fsf@bonsai.taydin.org>
References: <87bqjr401n.fsf@bonsai.taydin.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 18 Feb 2007 18:11:23 -0500
Message-Id: <1171840283.28092.3.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 (2.9.91-3.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 23:40 +0200, Timur Aydin wrote:
> reg is indeed 0xffff and the function returns -ENODEV.
> 
> I need help to further troubleshoot the problem, any directions or
> hints welcome...

The card is likely dead, but please check it with hostap_cs and on
different hardware just in case.  If you have further questions, please
post them to orinoco-devel@lists.sourceforge.net

-- 
Regards,
Pavel Roskin

