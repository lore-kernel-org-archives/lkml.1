Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXDOMpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXDOMpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 08:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXDOMpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 08:45:04 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:50698 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbXDOMpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 08:45:03 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17954.7753.258414.213430@gargle.gargle.HOWL>
Date: Sun, 15 Apr 2007 16:44:57 +0400
To: Ignatich <ignatich@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Newsgroups: gmane.linux.kernel
In-Reply-To: <462111F8.1060700@gmail.com>
References: <462111F8.1060700@gmail.com>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0001158 94f4495fd6f8ce612d0189f19128c22f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ignatich writes:
 > You might want to look at this discussion:
 > http://mail.opensolaris.org/pipermail/zfs-discuss/2007-April/027041.html

Licenses involved cover file system _code_, rather than storage format
that is openly specified. Just stand up and implement driver for zfs
format from scratch under whatever license you want. This is exactly how
Linux supports "foreign" file systems (ntfs, fat, etc.).

Nikita.

