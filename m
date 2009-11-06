Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZKFHn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZKFHn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZKFHn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:43:29 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:56138 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZKFHn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:43:28 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH v10 1/1] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Fri, 6 Nov 2009 08:43:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-self-00026-g91d3f9b; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       virtualization@linux-foundation.org
References: <1257266319-24300-1-git-send-email-amit.shah@redhat.com> <1257266319-24300-2-git-send-email-amit.shah@redhat.com>
In-Reply-To: <1257266319-24300-2-git-send-email-amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911060843.05934.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 03 November 2009 17:38:39 schrieb Amit Shah:

> drivers/char/Kconfig           |    6 +
> drivers/char/virtio_console.c  | 1412 ++++++++++++++++++++++++++++++++++++----
> include/linux/virtio_console.h |   50 ++-
> 3 files changed, 1332 insertions(+), 136 deletions(-)

I have not looked at your last two versions of the patch  since you did not add 
a changelog to your patch description. I thought you only did minor changes.
Turned out you added/changed several places. (e.g. VIRTIO_CONSOLE_CACHE_BUFFERS, 
VIRTIO_CONSOLE_THROTTLE_PORT  and VIRTIO_CONSOLE_BUFFER_LIMIT  are all new)

When you do bigger changes can you add a changelog in your patch description in 
the future?
