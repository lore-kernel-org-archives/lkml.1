Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbZI1Qhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbZI1Qhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZI1Qhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbZI1Qha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:37:30 -0400
Subject: Re: [PATCH] drm/radeon/kms: Convert RV515 to new init path and
 associated cleanup
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <1254155683-19832-1-git-send-email-jglisse@redhat.com>
References: <1254155683-19832-1-git-send-email-jglisse@redhat.com>
Content-Type: text/plain
Organization: redhat.com
Date: Mon, 28 Sep 2009 18:35:08 +0200
Message-Id: <1254155708.3075.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 18:34 +0200, Jerome Glisse wrote:
> Convert the rv515 asic support to new init path also add an explanation
> in radeon.h about the new init path. There is also few cleanups
> associated with this change (others asic calling rv515 helper
> functions).
> 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>

This is the good one, previous one were missing vram restriction
stuff. Sorry about all the spam with various bad version.

Cheers,
Jerome

