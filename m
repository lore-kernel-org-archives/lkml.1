Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZKIPSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZKIPSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZKIPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:18:48 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34770 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbZKIPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:18:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tEa/3/SWXSlp9tT2Hh747HcKYRyG6NzPcpGnwly+Z/W78Obd+e+HrQLLq48yKFv+XT
         QvRw2rTDMz6ckI7vItAFYnqCD/SXKIbDaZyO79/NM954S1ldvwemak1PSBiCPsET52Ue
         ht/S3ml5ErUEujphTfWW6j0Nq8IFw+F5DAEiU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: manual merge of the trivial tree with the  tree
Date: Mon, 9 Nov 2009 16:08:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
References: <20091109154305.49d3eb7c.sfr@canb.auug.org.au> <alpine.LSU.2.00.0911090944200.15039@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0911090944200.15039@wotan.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091608.36757.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009 09:45:50 Jiri Kosina wrote:

> From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Subject: rt2x00: fix some typos and punctuation in comments
> 
> fix some typos and punctuation in comments
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

FWIW the patch is in rt2800 tree now.

-- 
Bartlomiej Zolnierkiewicz
