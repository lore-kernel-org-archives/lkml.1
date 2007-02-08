Return-Path: <linux-kernel-owner+w=401wt.eu-S1422886AbXBHGah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422886AbXBHGah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 01:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422923AbXBHGah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 01:30:37 -0500
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:60298 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422886AbXBHGag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 01:30:36 -0500
From: Junio C Hamano <junkio@cox.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] net driver updates
References: <20070208002959.GA29961@havoc.gtf.org>
cc: linux-kernel@vger.kernel.org
Date: Wed, 07 Feb 2007 22:30:34 -0800
In-Reply-To: <20070208002959.GA29961@havoc.gtf.org> (Jeff Garzik's message of
	"Wed, 7 Feb 2007 19:29:59 -0500")
Message-ID: <7vired2mb9.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

>  mode change 100644 => 100755 drivers/net/qla3xxx.c
>  mode change 100644 => 100755 drivers/net/qla3xxx.h

Did you mean to have these?  Commit bd36b0ac appears to have
brought the mode bits change in.

Not trying to nitpick --- I am trying to find out if this was
caused by a git bug.


