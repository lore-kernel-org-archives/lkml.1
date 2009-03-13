Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbZCMOTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbZCMOTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZCMOSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:18:51 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:40624 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZCMOSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:18:51 -0400
Date: Fri, 13 Mar 2009 09:18:49 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: LKML <linux-kernel@vger.kernel.org>, lkml-scis@beardog.cca.cpqcorp.net
Cc: Steve Cameron <scameron@beardog.cca.cpqcorp.net>, tom.lawler@hp.com,
       iss_storagedev@hp.com
Subject: [RFC] hpsa: addressing review comments
Message-ID: <20090313141849.GA15269@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about the hpsa driver we recently released. We've received
quite a few comments, very positive overall. When we make the changes noted,
i.e., rip out /proc, style changes, etc., do we submit patches for that? Or
repost the entire driver with the appropriate changelog?

Thanks,
mikem
