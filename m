Return-Path: <linux-kernel-owner+w=401wt.eu-S1765806AbXHIKa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765806AbXHIKa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 06:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXHIKau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 06:30:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbXHIKat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 06:30:49 -0400
Date: Thu, 9 Aug 2007 11:31:22 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: Documentation files in html format?
Message-ID: <20070809113122.3aa508e4@oldman.hamilton.local>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the network device documentation needs a rewrite, I was thinking
of using basic html format instead of just plain text. But since this would
be starting an new precedent for kernel documentation, some it seemed
like a worthwhile topic for discussion.

Advantages of html:
  * basic formatting like lists, italics, etc
  * easier to integrate into other places and retain formatting
  * ability to link documents and to external sources easier

Downsides:
  * can become too formatted and unclear
  * accessibility and translation issues?
  * even more style issues

