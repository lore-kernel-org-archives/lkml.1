Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYJVXQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYJVXQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 19:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYJVXQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 19:16:02 -0400
Received: from sous-sol.org ([216.99.217.87]:58174 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751908AbYJVXQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 19:16:00 -0400
Date: Wed, 22 Oct 2008 16:15:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: update to the combined -stable tree
Message-ID: <20081022231545.GD7646@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those people who are using the combined stable tree (all stable
branches in a single git tree):

git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git

This is just a heads up that it has been replaced by a new tree.

The new tree has 2 new features.  First, the master branch is not some
random stale 2.6.22.6 commit, it's following Linus' tree.  Second, the
update mechanism is rewritten thanks to Peter, so it's kept much more
up to date.

Be prepared that despite the fact that the heads of each branch are the same,
a reclone is the probably easiest way to reconcile the change in repo layout.

thanks,
-chris
