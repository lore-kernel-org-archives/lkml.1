Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbXLJJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbXLJJtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXLJJtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:49:42 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:56329 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXLJJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:49:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TpS42H+fwLdiYQ5uRlFwd0pJJQW8JWvfue+Or54e6UQHVhxMbdgPQoooFAncb7kIEXFFAhqzkp4Gsu9XvmZ73PE3ykv1Hn2zndvCbC1qXgbG4l8MC3F7YAtYar0fOAJbZZ4yKc965XpRc4GooTEYaibYWJ4fE6LjxljDVSCJHnE=
Message-ID: <4104961b0712100149h69b1e1fas355b770f93affd03@mail.gmail.com>
Date: Mon, 10 Dec 2007 17:49:37 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What does "ordering by draining" mean?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am reading the source code of block I/O layer, and now seeing there
saying "ordering by draining" or "ordering by tag" in
include/blkdev.h,and the comments in that file says: "Hardbarrier is
supported with one of the following methods", but what do these two
methods exactly mean?

Thanks

Regards
Jason
