Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032Ab0A0OIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0A0OIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002Ab0A0OIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:08:12 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49030 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754991Ab0A0OIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:08:12 -0500
Date: Wed, 27 Jan 2010 17:08:09 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Josh Boyer <jwboyer@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 0/3 for 2.6.33] Some fixes for kfifo and FHCI
Message-ID: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

FHCI no longer builds after kfifo rework, this patch set is
used to fix the issues.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
