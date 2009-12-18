Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZLRQrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZLRQrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932182AbZLRQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:47:15 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:59250 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZLRQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:47:14 -0500
Message-ID: <4B2BB1DF.3030708@collabora.co.uk>
Date: Fri, 18 Dec 2009 16:46:23 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: cgroups and dbus
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm investigating the possibility of using cgroups as part of a
kernel-based dbus solution, specifically to seperate apps on the system
bus(es). If anyone has a good example of how to use cgroups I'd like to
see it, since the one in the kernel Documentation folder doesnt work for me.

I'd like to hear from anyone who has begun working on something similar
already, too.
