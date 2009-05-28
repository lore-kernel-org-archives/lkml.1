Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZE1BXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZE1BXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZE1BXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:23:45 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:53688 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbZE1BXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OwJbnUc2791I1LVqv3t08XUXH8rf1X+F3MVHBkjCZ+jlgVO0pl8+mJDMD/2GDTsJLE
         S26FgxZGJUqOdd4AZcVAHP+wdrWWKWckxpr3ALFlyi/5gcrTIrJx1I1qJ2Ea/vWDUHGh
         I48Jsz0AppEQxdNDHmBwuzzXobEr36yvGv/2o=
Date: Thu, 28 May 2009 09:25:01 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove duplicated declarations for sys_pipe2
Message-ID: <20090528012501.GA13855@hack>
References: <20090528.035016.930425077028184727.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528.035016.930425077028184727.yamato@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 03:50:16AM +0900, Masatake YAMATO wrote:
>Hi,
>
>sys_pipe2 is declared twice in include/linux/syscalls.h.
>
>
>
>Signed-off-by: Masatake YAMATO <yamato@redhat.com>
>

Amazingly we have this...

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

-- 
Live like a child, think like the god.
 
