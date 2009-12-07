Return-Path: <linux-kernel-owner+w=401wt.eu-S935448AbZLGQtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448AbZLGQtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935437AbZLGQtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:49:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:45200 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbZLGQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:49:11 -0500
Date: Mon, 7 Dec 2009 08:48:36 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Denis Loginov <dinvlad@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [065/119] V4L/DVB (12356): gspca - sonixj:
 Webcam 0c45:6148 added
Message-ID: <20091207164836.GB31258@suse.de>
References: <20091206235936.208334321@mini.kroah.org>
 <20091207000651.695885127@mini.kroah.org>
 <4B1D2652.6040707@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D2652.6040707@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 04:59:14PM +0100, Stefan Bader wrote:
> The patch generally looks ok, but seems to add several unnecessary
> commentary entries on other Ids. This could be either mis-generated
> diff or wanted things alike.

Keeping things identical to Linus's tree is always the best thing to do.
