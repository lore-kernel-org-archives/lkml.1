Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZI0Nbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZI0Nbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 09:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZI0Nbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 09:31:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:55028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZI0Nbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 09:31:42 -0400
Date: Sun, 27 Sep 2009 15:32:05 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [bisected] Wireless regression in 2.6.32-git
Message-ID: <20090927153205.4e3a1ee9@infradead.org>
In-Reply-To: <8db1092f0909270624l4fc46734u6a91f7cc7ffb0c72@mail.gmail.com>
References: <20090927151855.29efcc53@infradead.org>
	<8db1092f0909270624l4fc46734u6a91f7cc7ffb0c72@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 15:24:10 +0200
Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> Did You have similar messages in dmesg like this:
> 
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089
> (use WPA)

nope I don't get a Reason 6 disconnect...

(I get a reason 3 local choice, but that's true for working and
non-working both)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
