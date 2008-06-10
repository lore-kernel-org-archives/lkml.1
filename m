Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYFJTCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYFJTCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYFJTCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:02:37 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:55497 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756764AbYFJTCf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:02:35 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [PATCH] Unhide the SMBus on the Compaq Deskpro EN
Date: Tue, 10 Jun 2008 12:02:19 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       lm-sensors@lm-sensors.org, khali@linux-fr.org, rh1985@wp.pl
References: <20080608134702.401b9fb5.krzysztof.h1@wp.pl>
In-Reply-To: <20080608134702.401b9fb5.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806101202.20257.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 08, 2008 4:47 am Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>
> This patch unhides the SMBus on Compaq Deskpro EN
> SFF P667 with the Intel 815E chipset. Unhiding it reveals
> a THMC51 hardware monitoring chip.
>
> Jean Delvare has checked that this machine has no ACPI
> magic touching the SMBus nor the hardware monitoring chip,
> so this should be safe.
>
> The patch was tested on Fedora Core 9 with 2.6.25.4 kernel.
>
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> Tested-by: Rafa³ Ha³aduda <rh1985@wp.pl>
> CC: Jean Delvare <khali@linux-fr.org>

Thanks Krzysztof; applied to linux-next.  I had to fix up a conflict by hand 
though, would be good if you could double check it.

Thanks,
Jesse
