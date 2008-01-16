Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYAPQM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYAPQM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYAPQMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:12:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:41816 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYAPQMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=i9Bk5jue0fw08qdpIe0Satv+PtoHQUjbzqZLQ2YN8WZ9bWX6YtiADYgh86Ai4zfDOiqrP+NeXl1cT+FtBMzUSZxcE8VbegFzhPqZTd87nHUG8soL3BDjkO8/DA7GTeYB+UIcrjP4hRj2sVjeqyNmbR+6BD4vHAJjXS9WFo2WEpY=
Date: Wed, 16 Jan 2008 11:12:43 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Francisco Alecrim <francisco.alecrim@indt.org.br>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       dbrownell@users.sourceforge.net, kyle@parisc-linux.org,
       hcegtvedt@atmel.com
Subject: Re: [PATCH 3/6] drivers/char/keyboard.c: clean up remove
	duplicated headers
Message-ID: <20080116111208.ZZRA012@mailhub.coreip.homeip.net>
References: <1197658610-4558-1-git-send-email-francisco.alecrim@indt.org.br> <1197658610-4558-2-git-send-email-francisco.alecrim@indt.org.br> <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br> <1197658610-4558-4-git-send-email-francisco.alecrim@indt.org.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197658610-4558-4-git-send-email-francisco.alecrim@indt.org.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 02:56:47PM -0400, Francisco Alecrim wrote:
> Remove duplicated headers in drivers/char/keyboard.c:
> drivers/char/keyboard.c: linux/consolemap.h is included more than once.
> 
> Signed-off-by: Francisco Alecrim <francisco.alecrim@indt.org.br>

Applied, thank you Francisco.

-- 
Dmitry
