Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZHCTI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZHCTI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZHCTIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:08:25 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:48317 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZHCTIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:08:25 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: WMI module autoloading (for hp-wmi, dell-wmi, tc1100-wmi)
Date: Mon, 3 Aug 2009 20:08:11 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
Cc: linux acpi <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <4A76C1B8.6080000@tuffmail.co.uk>
In-Reply-To: <4A76C1B8.6080000@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032008.12387.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 03 Aug 2009 19:08:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009 11:53:44 Alan Jenkins wrote:
> Would it be possible to add the auto-load support on it's own?  Is it
> just a matter of someone taking the time to cherry-pick the auto-loading
> bits from the original patch, and test the result?

Yes. I started on this a while ago, but never quite finished.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
