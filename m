Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYAGRzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYAGRzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYAGRzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:55:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYAGRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:55:23 -0500
Message-ID: <47826773.2060303@zytor.com>
Date: Mon, 07 Jan 2008 09:54:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Michal Simek <simekm2@fel.cvut.cz>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu
Subject: Re: New linux arch
References: <47820D24.3060800@fel.cvut.cz> <84144f020801070447t68808bcdq64bfc949c7732462@mail.gmail.com> <Pine.LNX.4.64.0801071433510.14194@fbirervta.pbzchgretzou.qr> <478260C9.6040407@s5r6.in-berlin.de> <Pine.LNX.4.64.0801071838340.14194@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801071838340.14194@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 7 2008 18:26, Stefan Richter wrote:
>> Jan Engelhardt wrote:
>>>> On Jan 7, 2008 1:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
>>>>> Is it possible to create git repository in git.kernel.org for Microblaze
>>>>> cpu?
>> ...
>>> Alternatively, providing your own git service is just as effective,
>>> and comes with much more freedom :)
>> It is /almost/ as effective:
>>  - Many of the git trees on kernel.org are set up to share objects with
>> Linus' tree.
> 
> Oh? So `du -s davem/net-2.6.25` will not be like 170 megs in size?
> 

Nope:

: hera 9 ; du -sh davem/net-2.6.25.git
8.8M    davem/net-2.6.25.git

	-hpa
