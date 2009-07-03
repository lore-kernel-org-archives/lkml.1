Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbZGCNYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbZGCNYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZGCNY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:24:29 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:52844 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZGCNY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lCkJdWAJW8xAEE7cKhSiDzgsUA8FIj+Mcq922ItAcD6jNOmMnMFnAE+XV7+6UHKy2I
         sLmkEK+KOXy7RLAXrYbP3LqJQVG70+GtJRWAe4CXPeyena8tE9XiVMs2coc0MpsUpk70
         qzM/nkIyhWUSkE9qeGjqpDwd0tO00JEui5POg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH] Staging: vt6656: remove dependency on kernel version
Date: Fri, 3 Jul 2009 15:30:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1-next-20090703-03460-gb01c1b8; KDE/4.2.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, forest@alittletooquiet.net
References: <1246600379-9409-1-git-send-email-a.beregalov@gmail.com>
In-Reply-To: <1246600379-9409-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907031530.52033.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 07:52:59 Alexander Beregalov wrote:
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[ Hm... maybe I should be using Reviewed-by: since in my case ACK
  means (unless stated otherwise) that I audited the whole patch? ]
