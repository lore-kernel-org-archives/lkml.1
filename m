Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZB1TYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZB1TYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 14:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZB1TYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 14:24:30 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:55325 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZB1TY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 14:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=jUZkq7qFo0djIkwHg6siUEjiBDJ0hfSSLfWadqoKL/Gk6NYsYHHLsOVgD4NGSu15Yw
         j54HltRxBnlOX/QYDgI+T63NN96epyPumC7h517O7SHtJMc8uZHp5/xXsejdX3YNwY9m
         vXnW8OyN/5UNgyFHMJ57vEh+TYyEJFN/s7Ih4=
Message-ID: <49A98F6A.50702@gmail.com>
Date: Sat, 28 Feb 2009 19:24:26 +0000
From: Dave <kilroyd@googlemail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dwmw2@infradead.org, orinoco-users@lists.sourceforge.net
Subject: linux-firmware binary corruption with gitweb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm aware of at least a couple users of orinoco who have picked up
corrupt firmware# from the linux-firmware tree*.

I've verified that the firmware in the repository itself is correct.

It appears that downloading the file using the blob/raw links from
gitweb causes the corruption (0xc3 everywhere). At least it does with
firefox.

Is this known/expected behaviour?


Thanks,

Dave.

#<http://marc.info/?l=orinoco-users&m=123411762524637>
*<http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=shortlog>
