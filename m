Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZKES5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZKES5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbZKES52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:57:28 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49984 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054AbZKES50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=mHCNOPseY/xz9dVZwR8BmyS246g5OHKj+aQyz5LlNvXo/bMstm+dgh4Hmkr9FtuE4b
         bvEmklpWKcUiUtVjFINzO3SsJf6zbg5k+nDENhOgRCx5AQed2G05/T6b+Y31doEy8Jva
         QiBd1Ux+lm9ZfaFVozgJhLPmpgm8oQ3sjIDL4=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 25/41] rt2800pci: convert to use struct rt2800_ops methods
Date: Thu, 5 Nov 2009 19:57:29 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173500.28463.89800.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173500.28463.89800.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051957.29523.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: convert to use struct rt2800_ops methods
> 
> Add chipset registers access abstraction layer and prepare for later
> code unification.

See comment on patch [23/41]
