Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYAJLyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYAJLyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYAJLyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:54:24 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53344 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYAJLyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:54:23 -0500
Date: Thu, 10 Jan 2008 17:24:28 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, mingo@elte.hu, ak@suse.de, sam@ravnborg.org
Subject: [PATCH 0/7] Create and populate toplevel tests/ directory
Message-ID: <20080110115428.GA26577@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches create and populate the toplevel tests/
directory. This will henceforth be the place where all in-kernel tests
live.

All patches against 2.6.24-rc6-mm1

Ananth
