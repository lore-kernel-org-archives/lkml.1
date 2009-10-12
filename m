Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbZJLRCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbZJLRCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932816AbZJLRCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:02:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:47909 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbZJLRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UhgoBEydSrnQp5flTMxMSrSHZG4MADS/vxiwB+ByLzF/BQiBnjKD4u0aUzadQ2Q7nl
         iW8WlaBoTYMN5H9qk1TnzuYTzIONLQ2r3oHQ2fKNuIAJ466386GF8cyJV+/c99A4cera
         U/jF/4fx7LnKDH2xTnFPgv83n99hREGkKvoMA=
Date: Mon, 12 Oct 2009 19:01:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: add kernel command line graph function
	filtering
Message-ID: <20091012170125.GA5059@nowhere>
References: <4AD2DEB9.2@redhat.com> <c62985530910120209t3d263d5eh5aeba14fcecc9072@mail.gmail.com> <1255355219.7113.16.camel@gandalf.stny.rr.com> <c62985530910120659s4b1f3cbfq2f6adccb16cf2c23@mail.gmail.com> <1255357854.7113.18.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1255357854.7113.18.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:30:54AM -0400, Steven Rostedt wrote:
> On Mon, 2009-10-12 at 15:59 +0200, Frédéric Weisbecker wrote:
> 
> > No problem. I'll take the previous patch then, plus the kernel
> > parameter doc fix in the current one :-)
> 
> Great, so you'll pull in these changes then?
> 
> -- Steve


Yep, will push that soon. 

