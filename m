Return-Path: <linux-kernel-owner+w=401wt.eu-S937613AbZAPVJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937613AbZAPVJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937556AbZAPVJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:09:05 -0500
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:45017 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S937557AbZAPVJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:09:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=I2i1OlgU9sKTKalObzp/kibEGKLI9vH3GDTA1onkqSqIWQvYK4uczDaleaXInM2WmiIDK/TlGv/KCpUMw0Ene5Wj9hjJV7Ku3LmN3Lk3zhY+ZgZ5XoEjlT8QgkQr9hwB;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 7/7] PCI PCIe portdrv: Implement pm object
Date: Fri, 16 Jan 2009 10:20:01 -0800
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl> <200901131448.41843.rjw@sisk.pl>
In-Reply-To: <200901131448.41843.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161020.01955.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 13, 2009 5:48 am Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Implement pm object for the PCI Express port driver in order to use
> the new power management framework and reduce the code size.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I applied this series.  Hopefully you can Kenji-san can get on the same page 
wrt MSI vector handling so we can apply the last one from one of you. :)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
