Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbXGVL6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbXGVL6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 07:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXGVL6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 07:58:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54418 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbXGVL6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 07:58:20 -0400
Date: Sun, 22 Jul 2007 13:58:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jacob A <jacoba51-tmp@yahoo.com>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.4 Q: list of open files per inode?
In-Reply-To: <259547.37103.qm@web57705.mail.re3.yahoo.com>
Message-ID: <Pine.LNX.4.64.0707221358030.15705@fbirervta.pbzchgretzou.qr>
References: <259547.37103.qm@web57705.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22 2007 04:39, Jacob A wrote:

>I'm using the open/close call as a way for processes to
>register/unregister with a watchdog driver that I'm writing. I
>thought that I can save the housekeeping within the driver, but it
>looks like It would be easier just to maintain my own list and be
>done with it.

Sounds a bit wrong. _What_ exactly do you want to keep?


	Jan
-- 
