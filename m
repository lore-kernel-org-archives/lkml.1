Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZCXWes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZCXWes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZCXWef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:34:35 -0400
Received: from mail.vyatta.com ([76.74.103.46]:52200 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbZCXWee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:34:34 -0400
Date: Tue, 24 Mar 2009 15:34:27 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 v2.6.29
Message-ID: <20090324153427.3ff0dfdb@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to stay on top of things (for a change).

New version of iproute2 utilities that includes bug fixes and
support for all the new features in kernel 2.6.29.

  http://devresources.linux-foundation.org/dev/iproute2/download/iproute2-2.6.29.tar.bz2

Denys Fedoryschenko (1):
      Fix memory leak in local options

Jamal Hadi Salim (1):
      Breakage noticed when debian upgraded to xtables (iptables > 1.4.1)

Patrick McHardy (1):
      iproute: add DRR support

Stephen Hemminger (7):
      fix uninitialized memory in tc_skbedit
      Add missing limits.h
      Add DHCP as routing protocol
      Add support for IFALIAS
      Handle default hoplimit
      Use sanatized headers from 2.6.29
      Update snapshot
