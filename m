Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYC0RiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYC0RiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbYC0Rhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:37:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45886 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbYC0Rhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:37:53 -0400
Date: Thu, 27 Mar 2008 12:37:48 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, daniel@hozac.com,
       lizf@cn.fujitsu.com, Pavel Emelyanov <xemul@openvz.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
Message-ID: <20080327173748.GB8169@sergelap.austin.ibm.com>
References: <20080326180543.GA27709@sergelap.austin.ibm.com> <20080327020403.5547e43f.akpm@linux-foundation.org> <20080327162447.GA15147@sergelap.austin.ibm.com> <6599ad830803270940k261e1ae4r15f03f5014d9bec6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830803270940k261e1ae4r15f03f5014d9bec6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Thu, Mar 27, 2008 at 9:24 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >  Paul, did you have any plans of offering some sort of cft->read_seq()
> >  helper?
> 
> Yes, it's on my TODO list. It should just be a pretty simple extension
> of the existing read_map() support.

Ok, cool.  I can see about getting that done next week if you don't get
around to it, and convert the devices.allowed file to it.

thanks,
-serge
