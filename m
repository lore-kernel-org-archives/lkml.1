Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbZLGP7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbZLGP7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZLGP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:59:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58304 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZLGP7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:59:11 -0500
Message-ID: <4B1D2652.6040707@canonical.com>
Date: Mon, 07 Dec 2009 16:59:14 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Denis Loginov <dinvlad@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [065/119] V4L/DVB (12356): gspca - sonixj: Webcam
 0c45:6148 added
References: <20091206235936.208334321@mini.kroah.org> <20091207000651.695885127@mini.kroah.org>
In-Reply-To: <20091207000651.695885127@mini.kroah.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch generally looks ok, but seems to add several unnecessary
commentary entries on other Ids. This could be either mis-generated
diff or wanted things alike.

-Stefan
