Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbYG3UMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbYG3UMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYG3UMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:12:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYG3UMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:12:37 -0400
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
       x86@kernel.org, Bernhard Walle <bwalle@suse.de>
Subject: Fixes for firmware/memmap
Date: Wed, 30 Jul 2008 22:12:30 +0200
Message-Id: <1217448752-13859-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes coding style and also moves initialisation of kobject
to a safe point of time.


Signed-off-by: Bernhard Walle <bwalle@suse.de>


