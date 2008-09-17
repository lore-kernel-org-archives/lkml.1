Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYIQRJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYIQRJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYIQRIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 13:08:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36190 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754220AbYIQRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:08:54 -0400
Date: Wed, 17 Sep 2008 18:08:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Singaravelan Nallasellan" <singaravelann@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New IOCTLs
Message-ID: <20080917180851.170a219c@lxorguk.ukuu.org.uk>
In-Reply-To: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
References: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 22:25:35 +0530
"Singaravelan Nallasellan" <singaravelann@gmail.com> wrote:

> I need to send device control messages to the driver. I am planning to
> use the IOCTLs. But I came to know that Linux community does not
> accept any new IOCTLs anymore.

I don't know who told you that but its not true.
