Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZGAQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZGAQ3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZGAQ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:29:08 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58746 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZGAQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=GngHJvvRLuXKUHXeXazk89p4f+kzjCjNV6r6mQhoYJJYJTI9L4H6MWytFGsAcZ9xnb
         1V2w/qETr2iIwqzPnj6zXzmpk+KqSxD+TSo73DkFdtO0G1swfQesZIo5yVQeEmDlJIJU
         mc/gYJ4LlSEXi7sJJ3xPuLEx97KjOgGWhsauI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Wed, 1 Jul 2009 18:35:27 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1-next-20090701-03251-gbe98b01-dirty; KDE/4.2.4; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906240336.25263.bzolnier@gmail.com> <20090624.025518.75726622.davem@davemloft.net> <200906241248.21173.bzolnier@gmail.com>
In-Reply-To: <200906241248.21173.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907011835.27586.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 12:48:20 Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 24 June 2009 11:55:18 David Miller wrote:

[...]

> > I know you're busy, so I'll try to draft something up myself.
> 
> Ok, thanks.

Any news about these fixes?
