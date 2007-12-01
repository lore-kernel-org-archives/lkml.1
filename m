Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXLAUGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXLAUGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXLAUFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:05:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:39991 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXLAUFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:05:54 -0500
Message-ID: <4751BE0D.3050609@argo.co.il>
Date: Sat, 01 Dec 2007 22:03:25 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
In-Reply-To: <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> In the kernel though, there are many codepaths where *every* *single* 
> instruction counts; that could be a serious performance hit.

Write *those* *codepaths* in *C* or *assembly*. But only after you 
manage to measure a difference compared to the object-oriented systems 
language.

[I really doubt there are that many of these; syscall 
entry/dispatch/exit, interrupt dispatch, context switch, what else?]
