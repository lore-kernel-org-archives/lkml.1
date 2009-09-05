Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZIEGkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZIEGkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 02:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZIEGkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 02:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZIEGkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 02:40:18 -0400
Date: Sat, 5 Sep 2009 08:40:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/3] tracing - adding common method for
	reading/parsing user input
Message-ID: <20090905064007.GA5688@jolsa.redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com> <1252118486.6877.3.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252118486.6877.3.camel@desktop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 07:41:26PM -0700, Daniel Walker wrote:
> On Sat, 2009-09-05 at 03:12 +0200, jolsa@redhat.com wrote:
> > As 3 different places for 4 user input files were using the same way
> > of reading and parsing user's input, I made one common routine to be
> > used. 
> > 
> 
> Patches 1 and 3 have a couple of minor checkpatch errors.. 
> 
> Daniel
>

thanks, let me send out those changes later after I get other comments

wbr,
jirka
