Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXJCVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXJCVb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbXJCVbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:31:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:49720 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbXJCVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BCylcP7t83StCV/Ac//9FhgSnlaZeBMjpr42t56uCKkhek8CHETGBmWkmeR8mdm0YF9XfW75KfyQaigCdW+eEBG2h0zumcfxyZQolkSuB7OkY0ZziPcVnBai0X2vg9drX+76ynDCTuzk+h10otwQEAXXGyO1S+sZgkSDtPfSikg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [-mm patch] unexport noautodma
Date: Wed, 3 Oct 2007 23:35:22 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070909202521.GR3563@stusta.de>
In-Reply-To: <20070909202521.GR3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710032335.22749.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 September 2007, Adrian Bunk wrote:
> noautodma can now be unexported.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
