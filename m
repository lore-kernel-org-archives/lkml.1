Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXJ1QPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXJ1QPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXJ1QPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:15:39 -0400
Received: from main.gmane.org ([80.91.229.2]:59725 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXJ1QPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:15:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: [PATCH] backlight dimmer
Date: Sun, 28 Oct 2007 17:15:16 +0100
Message-ID: <87y7dndxm3.fsf@willow.rfc1149.net>
References: <4724B48D.6090405@antonello.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: zaphod.rfc1149.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:Zehfk4c+q0eEHEz0xa0XWyCqbiI=
X-Leafnode-NNTP-Posting-Host: 2001:6f8:37a:2::2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jacopo" == jack  <jack@antonello.org> writes:

Jacopo> this patch implements a macbook like backlight dimmer on top
Jacopo> of backlight.c.

Jacopo, if you want your patch to be reviewed, you should first put it
in an acceptable form. You can start by running it through
scripts/checkpatch.pl.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

