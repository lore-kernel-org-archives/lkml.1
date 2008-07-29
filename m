Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYG2X4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYG2X4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYG2X4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:56:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbYG2X4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:56:06 -0400
Date: Tue, 29 Jul 2008 16:54:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: mhoffman@lightlink.com, roberto@unbit.it,
       mactel-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/2] Support for Intel iMac in applesmc
Message-Id: <20080729165451.ce61578a.akpm@linux-foundation.org>
In-Reply-To: <488F30F7.4030804@boichat.ch>
References: <1216814135.5834.9.camel@sirius>
	<488F30F7.4030804@boichat.ch>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 23:02:15 +0800
Nicolas Boichat <nicolas@boichat.ch> wrote:

> Hi all,
> 
> Roberto De Ioris wrote:
> > Hi all, this patch (2.6.26 vanilla) add supports for fans and
> > temperature sensors on intel iMac.
> >
> > Tested on iMac 24" 2.8ghz (iMac8,1), it supports the following sensors:
> >   
> Here is a slightly modified version (Andrew realigned the sensors list).
> 
> Mark: If the MAINTAINERS file is correct, it should go in your git tree, 
> right?

Mark's been pretty quiet lately.  I put this patch in my "to be merged
into 2.6.27, by me if necessary" list.
