Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYAQAvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYAQAvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYAQAu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:50:58 -0500
Received: from lixom.net ([66.141.50.11]:33085 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYAQAu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:50:58 -0500
Date: Wed, 16 Jan 2008 19:01:30 -0600
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [patch 0/3] Remaining bits of WARN_ON series
Message-ID: <20080117010130.GA24663@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan posted a series of WARN_ON enhancements, parts of those were from
two previous patches from me.

Ingo picked up 3 of the 5 patches. Here are the rest-reposted again,
plus another patch bringing the generic report_bug() code up to the same
format as the x86-specific one.

These have to be applied on top of x86.git, since they depend on changes
in there. Ingo didn't want to take them directly since they touch code
in other architectures.

-Olof
