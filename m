Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbXCTQdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbXCTQdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXCTQdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:33:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:54505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964935AbXCTQdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:33:11 -0400
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: UDP packets scheduling
Date: Tue, 20 Mar 2007 09:31:46 -0700
Organization: OSDL
Message-ID: <20070320093146.5f208697@freekitty>
References: <20070320005228.GN22880@mail.muni.cz>
	<MDEHLPKNGKAHNMBLJOLKCEEACGAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1174408307 16263 10.8.0.54 (20 Mar 2007 16:31:47 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Tue, 20 Mar 2007 16:31:47 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 19:37:58 -0700
"David Schwartz" <davids@webmaster.com> wrote:

> 
> > can anyone suggest me a proper way how to schedule UDP packets to
> > transmit at
> > some given rate?
> >
> > E.g., I have two boxes both having 10 GE interfaces. One box is able to
> > transmit at 9.9Gbps, the other one is able to receive only at
> > about 5.5Gbps.
> > Flow control must be turned off for some other reason.

  "Those who do not understand TCP are condemned to reinvent it, poorly."


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
