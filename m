Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbXCZSTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbXCZSTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXCZSTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:19:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:51338 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbXCZSTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MNvjcOGJYVqBP+du3n4ybfXc0eNLV7+GgWFSb6TrX0kj62+Jkq/gikdH1hZw5WZ7CNv8qGtZjZ5ATQv7zPgv3Te3x3MqG4bSDmxUhJdtciIArNM+0YH7j7eC16rlJFwluKxbHoCl5vrh8+qD7rzmGXpgFjYjgDy+gkCyTpKA2Bs=
Message-ID: <a4e6962a0703261119q29943485m7e4c8b68b0bb0135@mail.gmail.com>
Date: Mon, 26 Mar 2007 13:19:42 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] 9p patches
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'for-linus' branch of:
   git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus

This tree contains the following:

Adrian Bunk(1):
  make struct v9fs_cached_file_operations static

 v9fs_vfs.h |    1 -
 vfs_file.c |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)
