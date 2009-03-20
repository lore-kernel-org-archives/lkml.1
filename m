Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZCTBnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZCTBnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZCTBne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:43:34 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:40901 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753783AbZCTBne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:43:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QWS9razF1InUf0a245E4KoxTlgyjBAbvuFlC0C1qUpPBtSp7j6g0oaE7pBSpn7mFLGdHVZRToQQaSafu7yUSUzWwW44N8mDxvOs3Z/SBAlDQfslauwoiKFQokRjN0PUh;
Date: Thu, 19 Mar 2009 18:43:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: Use kzalloc() in pci_create_bus()
Message-ID: <20090319184331.66a878a5@hobbes.lan>
In-Reply-To: <Pine.LNX.4.64.0903152009400.2201@anakin>
References: <Pine.LNX.4.64.0903152009400.2201@anakin>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Mar 2009 20:14:37 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
