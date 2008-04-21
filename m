Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYDUG3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYDUG3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYDUG3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:29:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60504 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYDUG3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:29:06 -0400
Date: Sun, 20 Apr 2008 23:35:21 -0700
From: Greg KH <greg@kroah.com>
To: Ryan_Permeh@McAfee.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: potential security issue
Message-ID: <20080421063521.GA5373@kroah.com>
References: <4195346499A4614AA5E42F9D082B6E0C017ED813@SNCEXMB3.corp.nai.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4195346499A4614AA5E42F9D082B6E0C017ED813@SNCEXMB3.corp.nai.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 10:12:01PM -0700, Ryan_Permeh@McAfee.com wrote:
> I need a security maintainer contact to discuss a potential security
> issue.  Due to the sensitive nature of the issue, I'd prefer to not
> discuss this in an open list.  Please provide me with a PGP key.  I've
> attached mine to ensure secure communications.  I am not a member of the
> list, so please respond to me directly.

See the file in the kernel tree, Documentation/SecurityBugs for
information on how to submit security related things, and who to send it
to (hint, security@kernel.org is the address).  That file also details
the conditions that the developers at that address follow (no long
disclosures, etc.)

thanks,

greg k-h
