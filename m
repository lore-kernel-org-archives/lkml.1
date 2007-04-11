Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbXDKVID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbXDKVID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXDKVIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:08:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXDKVIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:08:00 -0400
Message-ID: <461D4E2C.6000704@redhat.com>
Date: Wed, 11 Apr 2007 17:07:56 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Loud "pop" coming from hard drive on reboot
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I reboot my notebook, it powers off and powers back on.
On poweroff a loud snapping noise seems to be coming from the
hard drive. Today I noticed there is no "shutdown: hda" on
the console when I reboot. Whne I do a normal poweroff the
message is displayed and there is no noise. Should the IDE
code be changed so it always shuts down the drive?
