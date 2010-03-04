Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0CDWRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:17:36 -0500
Received: from thunk.org ([69.25.196.29]:40827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab0CDWRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:17:32 -0500
Date: Thu, 4 Mar 2010 17:17:28 -0500
From: tytso@mit.edu
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: dumpe2fs/dump/restore not working correctly for ext4?
Message-ID: <20100304221728.GH15028@thunk.org>
Mail-Followup-To: tytso@mit.edu, Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
References: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:19:57AM -0500, Justin Piszcz wrote:
> Hi,
> 
> I need to look into this more obviously and try other dumps etc, but
> I even tried extracting a single (smaller) directory and it also
> segfaulted, has dump been tested properly with ext4?

Was dump/restore statically or dynamically linked?  And with which
version of libext2fs from e2fsprogs?

						- Ted
