Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZIRFuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZIRFuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZIRFuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:50:19 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:14112 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZIRFuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PBQ9Qyt8W3YegmOlaTJxkEC8STbL36i0lWwapjLht6uUm01+aS93w5grPqEAbGk/3f
         1dPo329LbyduIc6838LKIP/ssPviqw9uVPYkKiCOW+y4vCzZ6gvYyZDQ4TVh4Fv3FKvU
         8Uodq1KEmB5RMrDIgVg2P2O8bymBJvHQy3/dA=
Date: Thu, 17 Sep 2009 22:42:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] input/keyboard: add ADP5588 QWERTY I2C Keyboard
	Input device driver
Message-ID: <20090918054239.GB18668@core.coreip.homeip.net>
References: <20090916050236.GF2756@core.coreip.homeip.net> <1253125231-17902-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253125231-17902-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 02:20:31PM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> v3
> 	- cache delay workaround calculation
> 	- rebase on latest mainline
> 

Applied, thanks Michael.

-- 
Dmitry
