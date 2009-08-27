Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZH0SWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZH0SWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 14:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZH0SWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 14:22:38 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:51360 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZH0SWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 14:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rxxl8yJxyaWHQnG9h64SoFh7CBTxqTMgcsvv96O7cumVC8aIQXAYtJhpPnWvmGIVlg
         0s/RVwTqhBjMQHZbNa0GYJMyaWRVxKf9jRTYJ2Md/UiU9v90BZGqZSPMQ47T2BWXGIJa
         XeWWLid4561DHHug7PVmy8pChOnRit25vlwzM=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 27 Aug 2009 11:22:19 -0700
Message-ID: <43e72e890908271122l6b08aaa5lc66de78301c7c88d@mail.gmail.com>
Subject: Would it help to encourage users to read/test stable-review patches
To: stable-review@kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just thinking out loud here.

We get development review eyes on stable patches during submission
into a subsystem, and perhaps 1-2 user tests then. Typically patches
are pretty easy to review for stable submission but I'm wondering
about cases where things are not so clear and perhaps we want better
testing and are less willing to take a fix into stable than on latest
rc. Also what if a user just wants to test an entire series queues up
for stable-review, is there a single all-in-one file user can just
patch -p1 to help test prior to getting the next stable release made?
Do we want more user exposure to stable-review mailing list or is just
a few developer eyes enough?

  Luis
