Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbZLFUq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbZLFUq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZLFUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:46:24 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60036 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757539AbZLFUqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:46:24 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: airlied@redhat.com
Subject: [PATCH 0/5] Add TTM functionality and drm exports for vmwgfx
Date: Sun,  6 Dec 2009 21:46:23 +0100
Message-Id: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds TTM functionality and a couple of drm exports needed by the
vmwgfx drm driver. The patch adding the vmwgfx driver itself will be posted
later. The current driver source is available at

git://git.freedesktop.org/git/mesa/vmwgfx


