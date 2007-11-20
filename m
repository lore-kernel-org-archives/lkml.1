Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXKTPow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXKTPow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759605AbXKTPnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:43:49 -0500
Received: from cet.com.ru ([195.178.208.66]:57232 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbXKTPne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:43:34 -0500
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [take8 0/4] dst: Distributed storage.
In-Reply-To: <asasdasdzxczc036@2ka.mipt.ru>
X-Mailer: gregkh_patchbomb
Date: Tue, 20 Nov 2007 18:24:00 +0300
Message-Id: <1195572240852@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Distributed storage.

I'm pleased to announce the 8'th release of the distributed
storage subsystem (DST). This is a maintenance release and includes
bug fixes only.

DST allows to form a storage on top of local and remote nodes
and combine them into linear or mirroring setup, which in
turn can be exported to remote nodes.

Short changelog:
 * cleanup sysfs files on error path.
	Patch by Chris Madden <chris@reflexsecurity.com>

Overall list of features of the DST can be found on project's homepage:

http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


