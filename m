Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220Ab0A0Ahz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0A0Ahz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305Ab0A0Ahy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:37:54 -0500
Received: from static-122-103-239-153.ng-fam.svips.gol.ne.jp ([122.103.239.153]:62171
	"EHLO priv.dyadic.cynic.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159Ab0A0Ahx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:37:53 -0500
Date: Wed, 27 Jan 2010 09:37:46 +0900
From: Curt Sampson <cjs@starling-software.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Problems Receiving UDP Broadcasts on Some Versions of Linux
Message-ID: <20100127003744.GA16322@analytic.cynic.net>
Mail-Followup-To: cjs@starling-software.com, linux-kernel@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
References: <20100125072749.GG21419@analytic.cynic.net> <4B5D51E6.5090601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5D51E6.5090601@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-01-25 09:10 +0100 (Mon), Eric Dumazet wrote:

> > The short summary is that on two very similar servers on the same
> > network, an application that listens for broadcast UDP packets on a
> > given port works fine on the Ubuntu 8.04/Linux 2.6.24-26-server box but
> > does not receive the packets on the Ubuntu 9.04/Linux 2.6.28-17-server
> > box.
>
> Could you post a sample of tcpdump trafic you receive on the 9.04
> host, and your network config ? "ifconfig -a"

I've added both to the end of the StackOverflow entry:

  http://stackoverflow.com/questions/2130563/udp-broadcast-reception-problems-with-ubuntu-9-04-but-not-8-04

Again, please cc me on any responses; I'm on neither the linux-kernel
nor netdev lists.

cjs
-- 
Curt Sampson         <cjs@cynic.net>         +81 90 7737 2974
             http://www.starling-software.com
The power of accurate observation is commonly called cynicism
by those who have not got it.    --George Bernard Shaw
