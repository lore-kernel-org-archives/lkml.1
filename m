Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbZFLDD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbZFLDD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZFLDDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:03:50 -0400
Received: from sous-sol.org ([216.99.217.87]:43031 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZFLDDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:03:49 -0400
Date: Thu, 11 Jun 2009 20:03:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] amd-iommu: kdump bugfix and couple defensive cleanups
Message-ID: <20090612030341.GQ20823@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix a kdump issue and then fix some similar
initialization issues that haven't proven to be problematic but make
good sense anyway.

thanks,
-chris
