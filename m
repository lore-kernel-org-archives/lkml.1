Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbYI0R3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbYI0R3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYI0R27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:28:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:26434 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYI0R24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ul6f202Dco9bu3gYsg6Hj7uO2Ovj8M3tZfz+6Fmfk0Pyfd5iWId+KunNcNA9/0H3SF
         4q+7UpA0J+leq4+7lAdG5Fj302j6zUVDhehl3/DK1j3xcXgHWFq+yq953cK5cOf/hnw6
         ztAz/S+VzMtWjzSKOzjP5YGMWaZv5iyCHmSb4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-cd: fix debug printk
Date: Sat, 27 Sep 2008 18:24:02 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080919173803.GA21355@gollum.tnic>
In-Reply-To: <20080919173803.GA21355@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271824.02288.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> please apply.
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Fri, 19 Sep 2008 19:30:46 +0200
> Subject: [PATCH] ide-cd: fix debug printk
> 
> failed_command can be NULL so check it before accessing it.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Thanks, I merged it into the original patch.
