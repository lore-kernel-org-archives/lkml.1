Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbYDWAND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbYDWAND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYDWAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:12:52 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:35824 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752344AbYDWAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:12:51 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
Date: Tue, 22 Apr 2008 17:12:45 -0700
User-Agent: KMail/1.9.9
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
In-Reply-To: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221712.45972.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2008 3:28 pm Jesper Juhl wrote:
> Running 'make oldconfig' I just noticed that PCIEASPM defaults to
> 'y' in Kconfig even though the feature is both experimental and the
> help text recommends that if you are unsure you say 'n'.
> It seems to me that this really should default to 'n', not 'y' at the
> moment.
> The following patch makes that change. Please consider applying.

Seem reasonable, Shaohua?  Please cc linux-pci on PCI patches though...

Thanks,
Jesse
