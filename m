Return-Path: <linux-kernel-owner+w=401wt.eu-S1763074AbYF3RVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763074AbYF3RVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYF3RVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:21:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbYF3RVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:21:35 -0400
Message-ID: <48691556.2080208@zytor.com>
Date: Mon, 30 Jun 2008 10:18:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>	<485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com> <m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
In-Reply-To: <486912C4.8070705@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> FYI, I did try this out and it caused the bootloader to scramble the
> loaded data.  The first corruption I found was the .x86cpuvendor.init
> section contained all zeroes.
> 

Explain what you mean with "the bootloader" in this context.

	-hpa
