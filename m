Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0BRKJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:09:51 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:35183 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab0BRKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:09:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=K28XoWIMOcrJSD2VTcXjo+a2mPfH1irWqfLM0VtVq0CNUNaP48MAg8V7IiIu8f2HSe
         2ydQk3UPUvn97GWOit4f1dY9pDztb16ykDS+bhZ7L4PqcA80fMGHDidSR0OmAh38tcoy
         xNhZjaWzJnXtvYnNuLYHF7WErM/XrD6erEO10=
Date: Thu, 18 Feb 2010 02:09:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc7
Message-ID: <20100218100938.GF13086@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Alan Jenkins (1):
      Input: i8042 - fix KBC jam during hibernate

Matthew Garrett (1):
      Input: add KEY_RFKILL


Diffstat:
--------

 drivers/input/serio/i8042.c |    8 ++++++++
 include/linux/input.h       |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

-- 
Dmitry

