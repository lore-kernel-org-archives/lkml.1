Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZGZNAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZGZNAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 09:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZGZNAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 09:00:15 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49520 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZGZNAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 09:00:14 -0400
Date: Sun, 26 Jul 2009 15:00:13 +0200
From: Andreas Mohr <andi@lisas.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andreas Mohr <andi@lisas.de>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc2: X stop accepting keystrokes?
Message-ID: <20090726130013.GA7918@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714095241.GA26272@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Symptoms are that I keep swearing over the system mixing up special key
> state (Ctrl, Alt, AltGr, etc.), resulting in all sorts of awful
> actions such as shell logout, view switch, going back to tty, killing
> text etc.pp.
> And sometimes full lockup of keyboard in X.

https://bugs.kde.org/show_bug.cgi?id=201561 . 'nuff said.

Andreas Mohr
