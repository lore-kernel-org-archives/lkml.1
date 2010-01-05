Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414Ab0AETeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0AETeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145Ab0AETd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:33:59 -0500
Received: from kroah.org ([198.145.64.141]:41199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab0AETdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:33:43 -0500
Date: Tue, 5 Jan 2010 11:29:12 -0800
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?Keng-Y=FC?= Lin <keng-yu.lin@canonical.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [2.6.31.stable] Input: atkbd - add force relese key
 quirk for Samsung R59P/R60P/R61P
Message-ID: <20100105192912.GB9681@kroah.com>
References: <1260178014-16741-1-git-send-email-keng-yu.lin@canonical.com>
 <20091216191938.GB16321@kroah.com>
 <d8fcdb790912202059v5e04b8a2j4fc10324c3c80fa9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8fcdb790912202059v5e04b8a2j4fc10324c3c80fa9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Mon, Dec 21, 2009 at 12:59:43PM +0800, Keng-Yü Lin wrote:
> Dear Greg:
>   This patch is not upstream. Since 2.6.32, there is an interface in
> /sys for handling the force_release events from userspace, so such
> quirk patches are no longer accepted upstream now. But this patch is
> valid for version 2.6.31 downwards.

Ok, thanks for the information.  Please tell me this in the future when
submitting patches for -stable otherwise I have no idea and will just
drop them.

greg k-h
