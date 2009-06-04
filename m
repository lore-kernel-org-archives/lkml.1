Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZFDGcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZFDGcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZFDGcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 02:32:03 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41292 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZFDGcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 02:32:02 -0400
Date: Thu, 4 Jun 2009 14:31:44 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Robert Berger <robert.berger@reliableembeddedsystems.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: http://patchwork.kernel.org/patch/26483/ broke my system boot
Message-ID: <20090604063144.GB7504@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090603143944.GF29326@balbir.in.ibm.com> <20090603194526.GG3100@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090603194526.GG3100@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg <sam@ravnborg.org> [2009-06-03 21:45:26]:

> On Wed, Jun 03, 2009 at 10:39:44PM +0800, Balbir Singh wrote:
> > After spending some time figuring out why my system failed to reboot,
> > checking config options, kernel version, modules installed. I figured
> > out that the patch in http://patchwork.kernel.org/patch/26483/ broke
> > the system boot on the latest mmotm. Reverting it helped my system
> > call depmod and hence boot.
> > 
> > The patch is really unhelpful, since the changelog is completely
> > empty. Sigh!
> 
> Yeah, sorry for not nak'ing it earlier. Has been busy.
> Andrew removed it from -mm and I notified the author about the
> problems with the patch (in private mail it seems - I just replied to what I had).

Cool! Thanks for the update. I'll get the latest mmotm and test as
well.

-- 
	Balbir
