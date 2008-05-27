Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYE0Q46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYE0Q46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbYE0Q4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:56:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45912 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbYE0Q4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:56:50 -0400
Date: Tue, 27 May 2008 09:54:30 -0700
From: Greg KH <greg@kroah.com>
To: Richard MUSIL <richard.musil@st.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with accessing stable git over http
Message-ID: <20080527165430.GC3699@kroah.com>
References: <47EA26E4.8060602@st.com> <20080404050718.GE23796@1wt.eu> <47F5E701.6020706@st.com> <4804A58E.5070104@st.com> <20080417212849.GA17653@kroah.com> <483BDE6A.8040404@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483BDE6A.8040404@st.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 12:11:54PM +0200, Richard MUSIL wrote:
> Hello Greg,
> 
> it seems git-update-server-info should be run regularly, because it
> looks like right now I am stuck at v2.6.24.4 and I cannot get anything
> from 2.6.25.y stable branch - the time you probably run it.
> Could you please fix it?

It should now work, sorry about this.

greg k-h
