Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596Ab0ADQev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0ADQev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552Ab0ADQes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:34:48 -0500
Received: from outbound-mail-107.bluehost.com ([69.89.22.7]:33624 "HELO
	outbound-mail-107.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753540Ab0ADQeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:34:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sX1pzVR7i8Jo1T3QSN7DOOV23+u8kgVgbbBKomKirIHDragbWUydzBdDFgPaW12DzzDiLcGqpzuuLtl1vMXvym1cZLLyw/gcVosvUrjRc0ZgV7pg4wVY2iCbhfFMqqM5;
Date: Mon, 4 Jan 2010 08:34:42 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcie, portdrv: style cleanup
Message-ID: <20100104083442.2f4ba7c5@jbarnes-piketon>
In-Reply-To: <4B26F68C.4050201@jp.fujitsu.com>
References: <4B26F68C.4050201@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 11:38:04 +0900
Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> No change in logic.
> 
> Before:
>   drivers/pci/pcie/portdrv_core.c:
>     total: 7 errors, 2 warnings, 508 lines checked
>   drivers/pci/pcie/portdrv_pci.c:
>     total: 4 errors, 2 warnings, 300 lines checked
> 
> After:
>   drivers/pci/pcie/portdrv_core.c:
>     total: 0 errors, 0 warnings, 506 lines checked
>   drivers/pci/pcie/portdrv_pci.c:
>     total: 0 errors, 0 warnings, 299 lines checked
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
