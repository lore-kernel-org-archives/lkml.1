Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYEIVuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYEIVuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYEIVua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:50:30 -0400
Received: from nn7.de ([85.214.94.156]:35031 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbYEIVu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:50:29 -0400
Subject: how to empty buffers/cache?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 May 2008 21:49:47 +0000
Message-Id: <1210369787.4142.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am trying to perform some benchmarks that involve reading the same big
file a couple of times from disk. However I would want to make sure that
the file is not buffered/cached by the kernel when I read the file a
second/third/etc time.

Is there a way (except rebooting/unmounting the disk) to clear the
buffers?

Thanks,
Soeren
