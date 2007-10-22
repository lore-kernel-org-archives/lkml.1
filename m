Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbXJVFVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbXJVFVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 01:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXJVFVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 01:21:13 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:61011 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbXJVFVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 01:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kJPlHiZO+VZ6JdPDdDyPHaAgu5ELGBWHvA8TC4m4QrabSI64fnYRPD/BBeL5/jL4w9qjmWFoZEGMV6nwzgH4UELzrWbuNWgwm1DFe/xmPtnVZ9+L2pttL2Nbh/AcajpizlXkRfdmpwmDthfaAmogiPxP7T+S+Cqijo263STRukM=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/1] INPUT/BF54x-KEYPAD driver:  Remove useless line -errno returned by irq_request
Date: Mon, 22 Oct 2007 01:21:06 -0400
User-Agent: KMail/1.9.7
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Andrey Panin <pazke@donpac.ru>,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1192687055-11935-1-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1192687055-11935-1-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710220121.07148.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Cc: Andrey Panin <pazke@donpac.ru>
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>

Applied, thank you Michael, Bryan.

-- 
Dmitry
