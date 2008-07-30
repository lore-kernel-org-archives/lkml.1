Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbYG3MNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbYG3MNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYG3MNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:13:21 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58979 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755962AbYG3MNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:13:21 -0400
Date: Wed, 30 Jul 2008 08:13:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: mcs6502@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs
	within VENDOR_IDs
Message-ID: <20080730121301.GA8283@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, mcs6502@gmail.com,
	linux-kernel@vger.kernel.org
References: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 06:50:50PM +1000, mcs6502@gmail.com wrote:
> The following 31 patches attempt to bring pci_ids.h back into order.

Why not just fold this into one patch?  I can't think of a good reason
to do this one vendor at a time.  (Aside from someone trying to do
Signed-off-by: Statistics whoring, of course.  :-)

						- Ted
