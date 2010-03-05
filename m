Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0CEIhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 03:37:09 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:60179 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0CEIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 03:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RB2UdnQeeoCevWIo15cLyzV3cKLwC05X6717fDLRyRqOIPbu/iA2J+m7+DQaniuT+6
         I8rvLMQc9CPi72i4DqiB0Kz/Hg2rWuZaUG6dJsXbzNYJmPrDiuZvvPGM2lmpKXFeZZa/
         MV5QSVquY60tuvXeUJgB56ownuIxCmCKoFWBo=
Date: Fri, 5 Mar 2010 00:36:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Scott Moreau <oreaus@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] gamecon: fix off by one range check
Message-ID: <20100305083658.GB20245@core.coreip.homeip.net>
References: <20100303070544.GB5086@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303070544.GB5086@bicker>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 10:05:44AM +0300, Dan Carpenter wrote:
> It should be >= GC_MAX not > GC_MAX.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied, thank you Dan.

-- 
Dmitry
