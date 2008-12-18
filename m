Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752805AbYLRRND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYLRRND (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYLRRLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:11:51 -0500
Received: from mail01.svc.cra.dublin.eircom.net ([159.134.118.17]:43768 "HELO
	mail01.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752367AbYLRRLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:11:48 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 0/3] virtio: indirect ring entries
Date: Thu, 18 Dec 2008 17:10:19 +0000
Message-Id: <1229620222-22216-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.6.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rusty,
        Here's something that has (apparently) been kicked around for
a while now and I think makes some sense.

        Avi has been especially pushing for it lately in the context
of high performance block I/O - I'll let him explain his thinking
there.

        The patches themselves are fairly trivial, there shouldn't be
anything too surprising here.

Cheers,
Mark.
