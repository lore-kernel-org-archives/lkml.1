Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbZB0B2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbZB0B2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZB0B2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:28:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44184 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZB0B2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:28:41 -0500
Date: Fri, 27 Feb 2009 01:28:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hannes Eder <hannes@hanneseder.net>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] fs/super.c: fix sparse warning: Using plain
	integer as NULL pointer
Message-ID: <20090227012837.GQ28946@ZenIV.linux.org.uk>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net> <20090222000459.17557.20005.stgit@vmbox.hanneseder.net> <154e089b0902261710ybebe696p2c87334b29bf08a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0902261710ybebe696p2c87334b29bf08a0@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 02:10:14AM +0100, Hannes Eder wrote:
> [Added To]
> 
> On Sun, Feb 22, 2009 at 1:05 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> > Fix this sparse warning:
> > ?fs/super.c:849:26: warning: Using plain integer as NULL pointer

May I suggest a better subject for those?  Namely,

Subject: NULL noise: <filename or glob>

Nobody _cares_ which tool generates that and boilerplates in subjects should
be as short as possible.
