Return-Path: <linux-kernel-owner+w=401wt.eu-S1030427AbXFHNKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427AbXFHNKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968901AbXFHNJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:09:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968802AbXFHNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LBUaJCAysfP2Zf4MTU0Xm9mKoGlddW7a6xpJrLvylVWYsOLkHyChbp/dOzXCzVzxrApfA7X98GQL99aoiI1wb8dwByMgTcw06d/Ewo1Or/CqNH5svty0q8EuJNSS2E/S7eHqxWdN624XvjmTEisUHk0jrbM3+Js794B0GV5xRKU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Peer Chen" <peerchen@gmail.com>
Subject: Re: [PATCH 3/3] PATA: Add the MCP73/77 support to PATA driver
Date: Fri, 8 Jun 2007 14:58:41 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "alan" <alan@redhat.com>,
       "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>,
       "htejun" <htejun@gmail.com>
References: <200706071827360318829@gmail.com>
In-Reply-To: <200706071827360318829@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081458.41360.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007, Peer Chen wrote:
> Add the PATA controller device ID to pci_ids.h for MCP73/MCP77.
> The patch base on kernel 2.6.22-rc4
>  
> Signed-off-by: Peer Chen <peerchen@gmail.com>

applied
