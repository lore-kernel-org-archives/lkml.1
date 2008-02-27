Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYB0SWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYB0SWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbYB0SVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:21:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:43351 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbYB0SVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=rgC/lurM7VFhk9wSlHZ08WxTWi79Uc6qTZP4wfsi/XfMY2ZNSMibBK/uIW0Z7zk+8e6Q+sRJ/+VIOgz6QmHlqM39qXGrGnc/cobK1Kw/eqznWLqGMHKjWdQHwsIfztbpQgVMleuk9X763XgV0JoMtDI1gjJFPURFrIpo1Ad3P4A=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/5] ide-cd: trivial fixes
Date: Wed, 27 Feb 2008 19:20:44 +0100
Message-Id: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are the ide-cd trivial fixes split in an easier to digest format. I
cannot do the md5sum check here since all of the patches change at least one
char but i hope that this'll be redundant here since they're trivially easy
to review :) now.

 drivers/ide/ide-cd.c |  591 +++++++++++++++++++++++++-------------------------
 1 files changed, 298 insertions(+), 293 deletions(-)

Thanks,
Boris.
