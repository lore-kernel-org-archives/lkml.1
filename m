Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbYDUT6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbYDUT6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbYDUT6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:58:12 -0400
Received: from cpc4-cbly1-0-0-cust583.glfd.cable.ntl.com ([86.16.162.72]:40080
	"EHLO crisp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755134AbYDUT6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:58:11 -0400
Date: Mon, 21 Apr 2008 20:58:06 +0100
From: paul <fox@crisp.demon.co.uk>
Message-Id: <200804211958.m3LJw6QM004827@crisp.demon.co.uk>
Reply-To: fox@crisp.demon.co.uk
To: bart.vanassche@gmail.com
Subject: Re: dtrace for linux
Cc: linux-kernel@vger.kernel.org
X-Mailer: CRiSP-Mail v4.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sun, Apr 20, 2008 at 1:17 AM,  <fox@crisp.demon.co.uk> wrote:
> >
> >  I would like to announce that I am working on dtrace for Linux.
> >  I have the userland dtrace binary compiled, along with the first
> >  pre-pre-alpha dtracedrv.ko module loaded into my kernel.
> 
> This is great news. How will this dtrace implementation differ from
> SystemTap (http://sourceware.org/systemtap/) ?
> 
> Bart.
> 
> 

Hello Bart,


I dont know systemtap all that well, other than what i have
read on the net and browsed in the source. systemtap is similar,
but dtrace provides a high level functional language (D) and
a set of methodologies and scripts which mean learning/training
will make it easier to use.

In addition, dtrace promises to be kernel safe (whether or not it
is will be down to how good a job I do I guess!)

