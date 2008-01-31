Return-Path: <linux-kernel-owner+w=401wt.eu-S1764857AbYAaH2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764857AbYAaH2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYAaH2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:28:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYAaH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:28:23 -0500
Message-ID: <47A17727.6090302@zytor.com>
Date: Wed, 30 Jan 2008 23:22:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: system without RAM on node0 boot fail
References: <200801302026.27130.yinghai.lu@sun.com>	 <200801302102.09510.yinghai.lu@sun.com>	 <Pine.LNX.4.64.0801302049180.15109@schroedinger.engr.sgi.com>	 <47A16616.9070606@zytor.com> <86802c440801302306g2a1ae11h52b883eed79b7e96@mail.gmail.com>
In-Reply-To: <86802c440801302306g2a1ae11h52b883eed79b7e96@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Jan 30, 2008 10:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Christoph Lameter wrote:
>>> x86 supports booting from a node without RAM?
> 
> it is a two sockets system. only 4G RAM installed on node1.
> 

"Node 1" is the boot CPU, though, right?

I don't know if the spec requires node 0 to be the boot node.  Probably not.

	-hpa

