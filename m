Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbXJZNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbXJZNij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 09:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXJZNi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 09:38:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:29656 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXJZNi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 09:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jzGuWD0cRpeijM5X99tUo7SzfKIVISzJKuY2bvUFk+VMXCwuVNPih2dLfxPd+LAz+qAD/Cg2YjPaMpmwq7zOgrb/q8Zq1XE3jZk9SVLn7wXzxBxBsPs+aK3i52sHdRCPhVRf4Q8pCYU1YJWZCxGXLJr+K+7EMCwqVKdJdYVif4I=
Message-ID: <d120d5000710260638i4f5d2780ied5bcaabebbaf137@mail.gmail.com>
Date: Fri, 26 Oct 2007 09:38:23 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rmk@arm.linux.org.uk, kernel@wantstofly.org, tony.luck@intel.com,
       jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org,
       bryan.wu@analog.com, adaplas@gmail.com
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Jeff Garzik <jeff@garzik.org> wrote:
>  drivers/input/touchscreen/h3600_ts_input.c |    4 ++--

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
