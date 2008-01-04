Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYADBUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYADBUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYADBTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:19:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:61225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYADBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:19:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=f3DJpum/9mryTlbc2dre8J8fxBXpQcDT0+coS/cATiWqel9hkoAMztkka6kLGd1Lz0FhQgcvofl4Yp+g1decpB8OnZMigTfbjXvdpm7p7IvQYkfAWPNV/lRL5i2noKcwoqjol6GFxeL44ymYWp4RYjAD9ore13YdfjQ/zphvaCA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 01/10] move ide-floppy historical changelog to Documentation/ide/ChangeLog.ide-floppy.1996-2002;
Date: Fri, 4 Jan 2008 01:36:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801040136.56767.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied with two minor fixes (and sorry for being such a pedant ;):

* Summary line moved to patch description and "ide-floppy: cleanup header"
  used instead.  Please try to keep summary line within 80-columns limit,
  otherwise it makes git-log output etc ugly.

* I don't know why scripts/checkpatch.pl doesn't complain but quilt did:

  Warning: trailing whitespace in lines 44,46,61,62 of Documentation/ide/ChangeLog.ide-floppy.1996-2002

  so I fixed it manually.
