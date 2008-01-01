Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYAARyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYAARyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYAARx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:53:56 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52431 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYAARxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:53:55 -0500
Date: Tue, 1 Jan 2008 18:53:54 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled 'time' option removal
In-Reply-To: <20080101134656.GG2360@does.not.exist>
Message-ID: <Pine.LNX.4.64.0801011852250.14900@fbirervta.pbzchgretzou.qr>
References: <20080101134656.GG2360@does.not.exist>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 1 2008 15:46, Adrian Bunk wrote:
>index 20c4c8b..93aac19 100644
>--- a/Documentation/feature-removal-schedule.txt
>+++ b/Documentation/feature-removal-schedule.txt
>@@ -233,10 +233,2 @@ Who:	Jean Delvare <khali@linux-fr.org>
> ---------------------------
>-
>-What:	'time' kernel boot parameter
>-When:	January 2008
>-Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
>-	enabled or disabled as needed
>-Who:	Randy Dunlap <randy.dunlap@oracle.com>
>-

I am sure the people who added themselves in the Who: line would have
taken care of this soon enough, I mean, it's just 19 hours into the
first day :-)
