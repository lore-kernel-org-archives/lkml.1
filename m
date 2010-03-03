Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0CCPuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:50:24 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:45109 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab0CCPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:50:23 -0500
Date: Wed, 3 Mar 2010 09:46:34 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
In-Reply-To: <20100303143450.GA25500@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.1003030946140.17922@router.home>
References: <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box>
 <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com> <20100302125306.GD19208@basil.fritz.box> <84144f021003020704s3abafc24t9b8ab34234094b79@mail.gmail.com>
 <20100303143450.GA25500@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Andi Kleen wrote:

> > But anyway, if you have real technical concerns over the patch, please
> > make them known; otherwise I'd much appreciate a Tested-by tag from
> > you for David's patch.
>
> If it works it would be ok for me. The main concern would be to actually
> get it fixed.

You do not have a testcase? This is a result of code review?

