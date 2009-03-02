Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZCBOhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZCBOhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZCBOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:36:55 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:32892 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZCBOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:36:55 -0500
Date: Mon, 2 Mar 2009 15:36:49 +0100
From: Daniel Mack <daniel@caiaq.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: lis3's ACPI dependency
Message-ID: <20090302143649.GA11072@buzzloop.caiaq.de>
References: <20090301132953.GF20813@buzzloop.caiaq.de> <49AAD3B1.4050501@tremplin-utc.net> <20090302005554.GB3223@buzzloop.caiaq.de> <49ABB22F.7040508@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49ABB22F.7040508@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, Mar 02, 2009 at 11:17:19AM +0100, Éric Piel wrote:
> > Ok, I'll start and seperate things then but will need you help with
> > testing as I don't have the hardware the driver was written for
> > originally. I do have, in turn, a custom board with this chip connected
> > via SPI.
> Very good.

Ok, just send a series of 5 patches. For some reason, git send-email ate
up the subject lines of the first two, sorry for that.

All together they do what I want - I can use the device now on my PXA
board. There might be some more updates I'll come up with later. For
now, I'd like to make sure I didn't break anything for HP laptops :)

Thanks,
Daniel

