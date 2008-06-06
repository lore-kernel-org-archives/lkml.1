Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbYFFQcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbYFFQcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYFFQcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:32:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbYFFQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:32:24 -0400
Date: Fri, 6 Jun 2008 16:32:22 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.6
Message-ID: <20080606163222.GA312@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Fri, 06 Jun 2008 16:32:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36.6.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.6.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.6

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.36.y.git

It only fixes a vulnerability in the netfilter ip_nat_snmp_basic module
(CVE-2008-1673). If you don't use it, you don't need to upgrade.

Willy
--
Summary of changes from v2.4.36.5 to v2.4.36.6
============================================

Chris Wright (1):
      asn1: additional sanity checking during BER decoding (CVE-2008-1673)

Willy Tarreau (1):
      Change VERSION to 2.4.36.6

