Return-Path: <linux-kernel-owner+w=401wt.eu-S1764771AbXFSThY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764771AbXFSThY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXFSThM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:37:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:9070 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761261AbXFSThL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:37:11 -0400
Date: Tue, 19 Jun 2007 21:37:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How would I do this? (expert tricks) OT
In-Reply-To: <684309.25266.qm@web52508.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0706192136510.5731@fbirervta.pbzchgretzou.qr>
References: <684309.25266.qm@web52508.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 19 2007 12:36, Marc Perkel wrote:
>
>Thanks Jan,
>
>I think what you sent me is workable. I noticed it
>goes to the file /var/log/messages. Is there a way to
>make it go to a specific file?

Configure your syslog daemon accordingly.


> Thanks a lot for your
>help. I've been experimenting with some new and very
>interesting ways to catch spam and this could be yet
>another breakthrough.



	Jan
-- 
