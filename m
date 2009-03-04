Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZCDJQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZCDJQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZCDJPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:15:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:57906 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZCDJPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cbK5fRUr/3PTHo8X4bFWV/ct+gUZraScfm6u/35bGyREFieF5xrfitKVSzKwqVrpGR
         BY696BCcg09PM/BcJv9i0OBBZrJ1miwJEUS8XCf3QKT0NurucRzlxrKS6FU64XmmdM4V
         uwqF/Q8H7CZ9wKITqx1fAHJyZvyBbl/tM5X5Y=
Date: Wed, 4 Mar 2009 01:15:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 0/5] WM97xx updates
Message-ID: <20090304091538.GD7394@dtor-d630.eng.vmware.com>
References: <20090303182402.GA29542@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303182402.GA29542@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Mar 03, 2009 at 06:24:03PM +0000, Mark Brown wrote:
> This patch series updates the review feedback from the first round and
> rolls in the additional patches from Mike Rapoport.  I've not addressed
> any of the comments for the at32 driver since I have no ability to test
> any changes to that driver but repost it for completeness.
> 

I applied first 4 patches to 'next' and will wait for Hans-Christian
comments on the at32 driver.

Thanks!

-- 
Dmitry
