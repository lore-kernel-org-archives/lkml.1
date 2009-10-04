Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbZJDTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbZJDTua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbZJDTu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:50:29 -0400
Received: from poutre.nerim.net ([62.4.16.124]:59589 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733AbZJDTu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:50:28 -0400
Date: Sun, 4 Oct 2009 21:49:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] More i2c updates for 2.6.32
Message-ID: <20091004214949.26ec5446@hyperion.delvare>
In-Reply-To: <20090927222548.3afe3aab@hyperion.delvare>
References: <20090927222548.3afe3aab@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 22:25:48 +0200, Jean Delvare wrote:
> Hi Linus,
> 
> Please pull some more i2c subsystem updates for Linux 2.6.32 from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus
> 
> These are mainly cleanups removing obsolete code from random i2c
> drivers, and moving documentation files where they belong.

Forget about that one, I'll send a new pull request shortly with a few
more fixes.

-- 
Jean Delvare
