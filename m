Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXIYORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXIYORQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXIYORD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:17:03 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43316 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbXIYORB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:17:01 -0400
Date: Tue, 25 Sep 2007 07:11:47 -0700
From: Greg KH <greg@kroah.com>
To: Richard MUSIL <richard.musil@st.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] - TPM device driver layer (tpm.c|h) - repost
Message-ID: <20070925141147.GA15217@kroah.com>
References: <46CD497F.8030207@st.com> <20070823092604.GA6057@kroah.com> <46F909CA.3030101@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F909CA.3030101@st.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 03:14:50PM +0200, Richard MUSIL wrote:
> Hello all,
> 
> sometime ago I submitted patch to TPM layer, originally I thought this
> patch could be accepted into kernel (see below). However,
> since this did not happen, I wonder, if there are some problems with the
> patch or whether I am expected to do/provide something else, in order to
> have it accepted.

That would be up to the maintainer of the TPM code, which last I looked
was Kylene and Marcel (both of whom should be on the tpmdd-devel list
and should have picked this up already...)

thanks,

greg k-h
