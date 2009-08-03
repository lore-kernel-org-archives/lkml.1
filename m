Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbZHCW5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbZHCW5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZHCW5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:57:10 -0400
Received: from dovecot.org ([82.118.211.50]:38693 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbZHCW5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:57:09 -0400
X-Greylist: delayed 1534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2009 18:57:09 EDT
Subject: rename() a directory over a symlink
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 03 Aug 2009 18:31:31 -0400
Message-Id: <1249338691.1216.136.camel@timo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a reason why it's not allowed? Would it be difficult to
implement it? Seems like it shouldn't be much different from renaming a
file over a symlink.


