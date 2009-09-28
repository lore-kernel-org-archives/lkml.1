Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZI1Qhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZI1Qhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZI1Qha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:37:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZI1Qh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:37:29 -0400
Subject: Re: [PATCH] drm/radeon/kms: Convert RV515 to new init path and
 associated cleanup
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <1254153171-13261-1-git-send-email-jglisse@redhat.com>
References: <1254153171-13261-1-git-send-email-jglisse@redhat.com>
Content-Type: text/plain
Organization: redhat.com
Date: Mon, 28 Sep 2009 18:09:45 +0200
Message-Id: <1254154185.3075.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 17:52 +0200, Jerome Glisse wrote:
> Convert the rv515 asic support to new init path also add an explanation
> in radeon.h about the new init path. There is also few cleanups
> associated with this change (others asic calling rv515 helper
> functions).
> 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>

Don't apply this patch it breaks r520 family, i will respawn one
along with r520 conversion, so we can have a bisectable working
history.

Cheers,
Jerome

