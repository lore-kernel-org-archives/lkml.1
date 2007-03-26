Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbXCZXvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbXCZXvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 19:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933812AbXCZXvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 19:51:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:65371 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933790AbXCZXvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 19:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ISbT187gvwnXdSm+IxKHEZ61Y9Pym57UV/XfBfur/06fn7ISx5TOba7NjoXlo4fOP8c4Agm2OHZ1bLLcvDpBfCK8dpMSzMeVQr75ymW/f0R0g2blqSinvAQm3wM7cdcKEYqWvhLtvtgjriEoanTpryyl2GAnIBbrm+0BhD7/HC0=
Message-ID: <8bd0f97a0703261651w4bd95847p85e0cb118f482efd@mail.gmail.com>
Date: Mon, 26 Mar 2007 19:51:40 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH -mm] Blackfin: rtc fix rtc_update_irq augument
Cc: "Andrew Morton" <akpm@linux-foundation.org>, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org
In-Reply-To: <1174904023.32691.75.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174904023.32691.75.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Wu, Bryan <bryan.wu@analog.com> wrote:
> Replacing class_dev to directly using rtc_dev.

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
-mike
