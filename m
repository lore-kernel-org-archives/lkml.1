Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbXEaP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbXEaP5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXEaP5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:57:12 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:54250 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXEaP5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:57:11 -0400
Date: Thu, 31 May 2007 11:56:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: 2.6.21-rt2..8 troubles
Message-ID: <20070531155611.GA9207@goodmis.org>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu> <46574DE4.2080900@rncbc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46574DE4.2080900@rncbc.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, May 25, 2007 at 09:58:12PM +0100, Rui Nuno Capela wrote:
>
> I wish I could give you more details, but the fact is I don't know
> where
> to look. The machine just freezes silently, again and again, with all
> kernels from -rt2 to -rt8 inclusive, with no traceable evidence, at
> least to my knowledge. The only symptom that I can come about is that,
> from some moment on and ever since, the system cannot start any new
> process anymore, or otherwise takes forever to realize and launch any
> new started process thread.
>

I have a box that looks like it's doing the same thing. Unfortunately
for now it's being used to test other things.

But I did do a show-task and see a bunch of D processes. I'll post that
output when I get that box free again.

-- Steve

