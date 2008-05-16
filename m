Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYEPRdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYEPRdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYEPRdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:33:24 -0400
Received: from fmailhost04.isp.att.net ([204.127.217.104]:57797 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751844AbYEPRdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:33:24 -0400
X-Originating-IP: [74.251.45.67]
Date: Fri, 16 May 2008 12:33:21 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080516123321.5674952c@osprey.hogchain.net>
In-Reply-To: <7723.10156.qm@web52901.mail.re2.yahoo.com>
References: <7723.10156.qm@web52901.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 20:06:23 +0100 (BST)
Chris Rankin <rankincj@yahoo.com> wrote:

> Specifically, with minicom running on 2.6.25.3, the console does not
> accept keystrokes although it does receive the boot log from the
> remote machine.
> 
> The serial console is being exported by a 2.6.25.3 kernel, and
> appears to be working correctly.

Serial console using minicom works fine for me under 2.6.25 and
2.6.25.4.  Keystrokes are accepted normally.

Jay
