Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYBQJmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYBQJmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 04:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYBQJmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 04:42:35 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:37054 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYBQJme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 04:42:34 -0500
Date: Sun, 17 Feb 2008 10:42:25 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: uli526x link problem solved, fix not on 2.6.25-rc2
Message-ID: <20080217094225.GA3929@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

There was a problem that affected all tulip based drivers and which has been
fixed in most of them, for uli526x the problem remains on 2.6.25-rc2 as the
fix has not yet been applied.

A discusion of this bug and the patch to fix it is at
http://bugzilla.kernel.org/show_bug.cgi?id=5839
Several people including myself have tested the patch and have stated that
it works ok.

I would encourage people with the proper permissions to submit this patch so
that it ends up on 2.6.25.

Thanks in advance!

Regards...
-- 
Manty/BestiaTester -> http://manty.net
