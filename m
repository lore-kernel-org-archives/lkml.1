Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbZJ3Wzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbZJ3Wzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933029AbZJ3Wzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:55:47 -0400
Received: from kroah.org ([198.145.64.141]:38970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933016AbZJ3Wy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/9] Documentation: ABI: rename sysfs-devices-cache_disable properly
Date: Fri, 30 Oct 2009 15:54:22 -0700
Message-Id: <1256943268-12164-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

Rename sysfs-devices-cache_disable to sysfs-devices-system-cpu, in
order to keep a stricter correlation between a sysfs directory and
its documentation.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 ...ices-cache_disable => sysfs-devices-system-cpu} |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/ABI/testing/{sysfs-devices-cache_disable => sysfs-devices-system-cpu} (100%)

diff --git a/Documentation/ABI/testing/sysfs-devices-cache_disable b/Documentation/ABI/testing/sysfs-devices-system-cpu
similarity index 100%
rename from Documentation/ABI/testing/sysfs-devices-cache_disable
rename to Documentation/ABI/testing/sysfs-devices-system-cpu
-- 
1.6.4.2

