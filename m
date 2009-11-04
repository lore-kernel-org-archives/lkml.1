Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZKDQmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZKDQmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbZKDQmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:42:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1223 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbZKDQme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:42:34 -0500
Subject: Re: [PATCH 5/8] drivers/media/video/uvc: Use %pUl to print UUIDs
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-media@vger.kernel.org
In-Reply-To: <200911041542.30543.laurent.pinchart@ideasonboard.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
	 <200910312010.39785.laurent.pinchart@ideasonboard.com>
	 <1257017258.1917.138.camel@Joe-Laptop.home>
	 <200911041542.30543.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 08:42:38 -0800
Message-ID: <1257352958.10415.28.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 15:42 +0100, Laurent Pinchart wrote:
> Andrew, could you please drop drivers-media-video-uvc-use-%pul-to-print-
> uuids.patch ? I will push it through the v4l-dvb tree as I need to add 
> backward compatibility support.

One thing you might evaluate is how useful it is to continue
to support backward compatibility.

I think drivers/media is the only drivers directory except
staging to continue to use KERNEL_VERSION checks.

cheers, Joe

