Return-Path: <linux-kernel-owner+w=401wt.eu-S1761865AbYBLJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865AbYBLJ3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYBLJ3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:29:32 -0500
Received: from rosi.naasa.net ([212.8.0.13]:58059 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYBLJ3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:29:31 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH - BUGFIX] Smack: Check for 'struct socket' with NULL sk
Date: Tue, 12 Feb 2008 10:29:27 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, casey@schaufler-ca.com
References: <200802111926.03067.jplatte@naasa.net> <20080211232347.GA3635@ubuntu>
In-Reply-To: <20080211232347.GA3635@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802121029.28343.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 12. Februar 2008 schrieb Ahmed S. Darwish:
> Hi Joerg,
>
> There's a small problem with smack and NFS. A similar report was also
> sent here: http://lkml.org/lkml/2007/10/27/85
>
> Could you please check below patch ? I think it should fix your problem.

Hi Ahmed,

your patch fixes the nfs problem! Thank you!

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

