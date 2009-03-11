Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbZCKRRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbZCKRRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZCKRRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:17:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:2039 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZCKRRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QjwtlT1z6t+Xoyk5fXKgg1Qgl/+9UU0qH+PXqJgTOWAXUHQGdabWMEOhcTBvOi2kiK
         gMBDnBUMkf9+rFl002auJRC5PE5uIyO3CwhHGNLrUGAfYvO0hEnmyR2csCEb+cM5vqER
         DABMuZTgUJRxjqx3bvVzl2uXzbqBC0vAdZ8DQ=
MIME-Version: 1.0
In-Reply-To: <1228430755-4221-1-git-send-email-felipe.contreras@gmail.com>
References: <1228430755-4221-1-git-send-email-felipe.contreras@gmail.com>
Date: Wed, 11 Mar 2009 22:47:41 +0530
Message-ID: <5d5443650903111017n9c818b0y2119d06ea84c3abf@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] omapfb: Fix argument of blank 
	operation.
From: Trilok Soni <soni.trilok@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-omap@vger.kernel.org,
       Felipe Contreras <felipe.contreras@nokia.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, Dec 5, 2008 at 4:15 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> From: Felipe Contreras <felipe.contreras@nokia.com>
>
> The blank operation should receive FB_BLANK_POWERDOWN, not
> VESA_POWERDOWN.
>

Thanks. Looks good.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
