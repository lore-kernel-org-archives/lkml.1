Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbZKESwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbZKESwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758587AbZKESwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:52:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:35134 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbZKESv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=BMTWpncN3xDTIfdLWhJtysw6RsvDKKnE8YZY+7hs/yxOw9HJOyMDujYi1Uw6C8Nvzh
         suaTxI/TILWImubVra407kQ2GiCHpN82PjQKSNvc5OSCqGDprz3Htzbtce4eGkYQZgRM
         yxfTQ+1bCNPvBhsxr1WFCJT+RFEd89LjYiy28=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 22/41] rt2800pci: add rt2800_mcu_request() wrapper
Date: Thu, 5 Nov 2009 19:52:00 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173439.28463.20951.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173439.28463.20951.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051952.00730.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add rt2800_mcu_request() wrapper
> 
> Part of preparations for later code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

