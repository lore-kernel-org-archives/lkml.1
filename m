Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbYHDRVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbYHDRVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758639AbYHDRUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:20:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49369 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbYHDRUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:20:48 -0400
Subject: Too many I/O controller patches
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org,
       Andrea Righi <righi.andrea@gmail.com>
In-Reply-To: <20080804.175126.193692178.ryov@valinux.co.jp>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 10:20:33 -0700
Message-Id: <1217870433.20260.101.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 17:51 +0900, Ryo Tsuruta wrote:
> This series of patches of dm-ioband now includes "The bio tracking mechanism,"
> which has been posted individually to this mailing list.
> This makes it easy for anybody to control the I/O bandwidth even when
> the I/O is one of delayed-write requests.

During the Containers mini-summit at OLS, it was mentioned that there
are at least *FOUR* of these I/O controllers floating around.  Have you
talked to the other authors?  (I've cc'd at least one of them).

We obviously can't come to any kind of real consensus with people just
tossing the same patches back and forth.

-- Dave

