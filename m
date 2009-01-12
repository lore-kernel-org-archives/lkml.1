Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZALRyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZALRyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZALRxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:53:53 -0500
Received: from vena.lwn.net ([206.168.112.25]:38438 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbZALRxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:53:52 -0500
Date: Mon, 12 Jan 2009 10:53:48 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Theodore Tso <tytso@mit.edu>
Cc: Wang Chen <wangchen@cn.fujitsu.com>, Greg KH <gregkh@suse.de>,
       David Miller <davem@davemloft.net>, jaswinderlinux@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Who wrote 2.6.28
Message-ID: <20090112105348.127debb4@bike.lwn.net>
In-Reply-To: <20090112174927.GG21793@mit.edu>
References: <496224D7.2030109@cn.fujitsu.com>
	<3f9a31f40901090609n29b4e36dwe6fff7fdfc705c7e@mail.gmail.com>
	<20090109.141124.154196743.davem@davemloft.net>
	<20090110213121.GF31579@mit.edu>
	<20090110220004.GA5875@suse.de>
	<496AA506.20900@cn.fujitsu.com>
	<20090112174927.GG21793@mit.edu>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 12:49:27 -0500
Theodore Tso <tytso@mit.edu> wrote:

> One of the things which get confusing is that people's employers
> change over time, so if you are mapping engineers to company, it's not
> enough to use just an e-mail address and map it to a company name;
> ideally you need to take an e-mail address and/or name and date range,
> and then map that to a compay name.  For example Alan Cox was
> previously at Red Hat, but he will be changing employers to Intel as
> of some date in January, 2009, but he will be keeping his e-mail
> address.

FWIW, the gitdm code handles that just fine.  Of course, it does
require keeping the database current, which is always a challenge. 

jon
