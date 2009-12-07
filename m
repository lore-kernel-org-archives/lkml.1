Return-Path: <linux-kernel-owner+w=401wt.eu-S934847AbZLGUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847AbZLGUTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933732AbZLGUTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:19:40 -0500
Received: from adelie.canonical.com ([91.189.90.139]:41464 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbZLGUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:19:39 -0500
Message-ID: <4B1D635F.1000207@canonical.com>
Date: Mon, 07 Dec 2009 21:19:43 +0100
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
References: <20091206235936.208334321@mini.kroah.org> <20091207000651.695885127@mini.kroah.org> <4B1D2652.6040707@canonical.com> <20091207164836.GB31258@suse.de>
In-Reply-To: <20091207164836.GB31258@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Dec 07, 2009 at 04:59:14PM +0100, Stefan Bader wrote:
>> The patch generally looks ok, but seems to add several unnecessary
>> commentary entries on other Ids. This could be either mis-generated
>> diff or wanted things alike.
> 
> Keeping things identical to Linus's tree is always the best thing to do.

Ok, agreed.

-Stefan
