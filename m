Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZKEUv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZKEUv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbZKEUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:51:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:7267 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859AbZKEUvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:51:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IrD19k440DPg5BcYV3htqtVHnlyv8Bry47l+WH1wkPvtNRZGz0wLO2hGLl2WatYRCE
         zOcras9dE7Hf7OBYadOd+LSb944kh0YyQji+Djt3Q+UMs0ChcmCCA4+jc9ioDH9I5Dhe
         gdfts7yUR1LwcmuY+2m1UHTuH4nZcinl0h+ks=
Message-ID: <4AF33AE9.6050205@gmail.com>
Date: Thu, 05 Nov 2009 21:51:53 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 39/41] rt2x00: move REGISTER_BUSY_* definitions to rt2x00.h
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173650.28463.23162.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173650.28463.23162.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/09 18:36, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: move REGISTER_BUSY_* definitions to rt2x00.h
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
