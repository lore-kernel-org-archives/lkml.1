Return-Path: <linux-kernel-owner+w=401wt.eu-S1751562AbZIENCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbZIENCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 09:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZIENCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 09:02:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65079 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZIENCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 09:02:42 -0400
Subject: Re: [PATCHv2 0/3] tracing - adding common method for
 reading/parsing user input
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: Daniel Walker <dwalker@fifo99.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090905064007.GA5688@jolsa.redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
	 <1252118486.6877.3.camel@desktop>  <20090905064007.GA5688@jolsa.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 05 Sep 2009 09:02:41 -0400
Message-Id: <1252155761.21261.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 08:40 +0200, Jiri Olsa wrote:
> On Fri, Sep 04, 2009 at 07:41:26PM -0700, Daniel Walker wrote:
> > On Sat, 2009-09-05 at 03:12 +0200, jolsa@redhat.com wrote:
> > > As 3 different places for 4 user input files were using the same way
> > > of reading and parsing user's input, I made one common routine to be
> > > used. 
> > > 
> > 
> > Patches 1 and 3 have a couple of minor checkpatch errors.. 
> > 
> > Daniel
> >
> 
> thanks, let me send out those changes later after I get other comments

I wont be able to look at these until next week.

-- Steve


