Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbZKEUhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbZKEUhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbZKEUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:37:22 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40993 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZKEUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=js48XpOX1NUaTu829nIn1yOm9N/nbeegalJbmpKv1cZWGiBVNqJX3HG576W+yzfH7B
         oC5jomhbqXgSFxj7yF1VLhUjfZAOJHTvw8eNWwGMIjep9PG3JY0oEKlzkuwSG8O6VZ5n
         hNklI8p0d13RZpd7SvM1VbZer5yP6ikPGoraU=
Message-ID: <4AF33783.5000804@gmail.com>
Date: Thu, 05 Nov 2009 21:37:23 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 32/41] rt2800: fix duplication in header files
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173554.28463.72619.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173554.28463.72619.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/09 18:35, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: fix duplication in header files
> 
> Updated debugging scripts are located here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/bart/rt2800/scripts/
> 
> (they also work fine with older drivers)
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
