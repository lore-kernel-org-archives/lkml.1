Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYHHRCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYHHRCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYHHRCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:02:08 -0400
Received: from www17.your-server.de ([213.133.104.17]:46715 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYHHRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:02:08 -0400
Subject: next-20080808: bash: fork: Resource temporarily unavailable
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 19:02:15 +0200
Message-Id: <1218214935.3146.5.camel@dhcppc0>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Beginning with next-20080808 after letting the system run for 5 minutes
or so, I get an error from the fork call, e.g.:

"bash: fork: Resource temporarily unavailable"

Doing an "echo c > /proc/sysrq-trigger" I was able to get an vmcore dump
of the running kernel using the kdump mechanism.

what should i do next?

with kind regards
thomas


