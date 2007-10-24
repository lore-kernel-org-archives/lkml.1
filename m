Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbXJXCkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbXJXCkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbXJXCkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:40:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48189 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXJXCkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:40:08 -0400
Message-ID: <471EB085.5080604@garzik.org>
Date: Tue, 23 Oct 2007 22:40:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Wakko Warner <wakko@animx.eu.org>
Subject: Re: How do I get my aic94xx to see sata drives?
References: <20071024022124.GA6226@animx.eu.org>
In-Reply-To: <20071024022124.GA6226@animx.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wakko Warner wrote:
> Please CC me.

Please don't use

	Mail-Followup-To: linux-kernel@vger.kernel.org

in your emails then :)


> I've looked around and the only thing I can find was a git repository for
> it.  I don't know anything about git.  I just want to get the driver so I
> can use the sata drives I have on this controller.
> 
> I'm currently using 2.6.22.

hum, it should be working in 2.6.22.  There were some minor fixes and 
changes in 2.6.23 that you might want to try, but overall, we are 
interested in your bug report.

	Jeff



