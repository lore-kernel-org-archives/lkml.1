Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbYCXNMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbYCXNMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 09:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbYCXNMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 09:12:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbYCXNMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 09:12:40 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: wait until PHY configuration packet was transmitted
Date: Mon, 24 Mar 2008 09:04:17 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.47c2348a94015e02@s5r6.in-berlin.de> <47E4DDFB.4050600@s5r6.in-berlin.de> <47E5D0B6.6090307@redhat.com>
In-Reply-To: <47E5D0B6.6090307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803240904.18077.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2008 11:38:30 pm Jarod Wilson wrote:
> Stefan Richter wrote:
> > Jarod Wilson wrote:
> >> Will double-check Monday that this solves never-ending (until panic) bus
> >
> > s/that/whether/? :-)
>
> Either one works here. I went with "that", because I'm reasonably
> certain that it does solve the problem and I'll just be confirming it,
> vs. suspecting it might and finding out whether it does or not... Or
> something like that. :)
[...]
> >> resets with a jmicron controller in the office

And it does in fact solve the constant bus reset problem on the jmicron 
controller.

-- 
Jarod Wilson
jwilson@redhat.com
