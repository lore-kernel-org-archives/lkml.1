Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZKMRnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZKMRnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZKMRnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:43:31 -0500
Received: from fifo99.com ([67.223.236.141]:49790 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbZKMRn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:43:26 -0500
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Daniel Walker <dwalker@fifo99.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
	 <1252940549.28368.255.camel@desktop>
	 <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 09:43:27 -0800
Message-Id: <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 02:23 +0200, Felipe Contreras wrote:
> On Mon, Sep 14, 2009 at 5:02 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Mon, 2009-09-14 at 17:34 +0300, Felipe Contreras wrote:
> >> I did... the style issues are already there, my patch is not
> >> introducing them. Do you want me to send a separate patch to fix the
> >> existing style issues?
> >
> > Yes, If your inclined to clean up the whole file, or just the
> > surrounding code that would be helpful ..
> 
> Nobody seems to like the patch you suggested me to do... did I wasted
> my time doing it?
> http://article.gmane.org/gmane.linux.acpi.devel/42383

Did you get some negative feedback ? I don't see any..

Daniel

