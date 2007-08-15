Return-Path: <linux-kernel-owner+w=401wt.eu-S936395AbXHOUkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936395AbXHOUkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936468AbXHOUj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:39:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46289 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936461AbXHOUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:39:55 -0400
Date: Wed, 15 Aug 2007 13:39:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, bob.picco@hp.com, nacc@us.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
In-Reply-To: <1187201237.5422.42.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708151339360.7628@schroedinger.engr.sgi.com>
References: <1187115224.6281.40.camel@localhost>  <20070814192306.GB32553@vino.hallyn.com>
  <20070814204951.GA2065@vino.hallyn.com>  <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
  <1187127685.6281.139.camel@localhost>  <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
  <1187185392.5422.13.camel@localhost>  <20070815143125.GA11582@vino.hallyn.com>
  <1187195028.5422.30.camel@localhost>  <20070815163142.GA12850@vino.hallyn.com>
  <20070815165234.GC1179@linux.vnet.ibm.com> <1187201237.5422.42.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Lee Schermerhorn wrote:

> Thanks for testing.  If Christoph agrees, I'll repost to -mm to request
> merging.

Please do. Looks right from what I can tell so far.

