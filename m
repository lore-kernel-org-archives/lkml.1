Return-Path: <linux-kernel-owner+w=401wt.eu-S935064AbYBGVG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064AbYBGVG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933448AbYBGUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44402 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbYBGUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:48 -0500
Subject: Re: [PATCH][DOCUMENTATION] Minimal controller code for a quick
	start
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <6599ad830802071249g45cb2d6eybd00c1bef07cf5aa@mail.gmail.com>
References: <47AB25AD.30400@openvz.org> <1202416137.6274.42.camel@lappy>
	 <6599ad830802071249g45cb2d6eybd00c1bef07cf5aa@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 21:52:33 +0100
Message-Id: <1202417553.6274.44.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 12:49 -0800, Paul Menage wrote:
> On Feb 7, 2008 12:28 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > While on the subject, could someone document struct cgroup_subsys.
> 
> There's documentation for all the methods in Documentation/cgroup.txt

Hehe, and here I was looking for in-code comments. OK I'll read the
thing.

