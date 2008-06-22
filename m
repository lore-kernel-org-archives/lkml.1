Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYFVRA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYFVRA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYFVRAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:00:18 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:4609 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYFVRAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EjK04Y2rvohdGa6FkL3eOcdQ53p3bg0iFaWD0eR7l89/TKUZeoh4HHIgsut7dvJiD3
         OvLEC7GGkXDOz1elmkOes5IULbevaFJmYoV5mVWggDrIGbgXmmAhDkMrQaFQqTJeMa1K
         0j+hK44BJ5mkjpsYekXF1wKOaV0XM6RseP2ek=
Date: Sun, 22 Jun 2008 21:00:05 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net
Subject: Re: [PATCH] leds: make sure led->trigger is valid before calling
	trigger->activate
Message-ID: <20080622170005.GB14117@doriath.ww600.siemens.net>
References: <20080619114847.GA13752@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619114847.GA13752@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 19, 2008 at 03:48:47PM +0400, Dmitry Baryshkov wrote:
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/leds/led-triggers.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 

Any comments about this?

-- 
With best wishes
Dmitry

