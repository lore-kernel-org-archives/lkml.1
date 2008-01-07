Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYAGQKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYAGQKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYAGQK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:10:29 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:60993 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYAGQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:10:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AplZAC/dgUdT48OPQWdsb2JhbACBWI4yAQEBHhmBIpY2
Message-ID: <47824A6F.9090503@coderworld.net>
Date: Mon, 07 Jan 2008 16:51:11 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
References: <477BFC71.7090002@coderworld.net> <20080102214843.GA19224@rhlx01.hs-esslingen.de> <20080102234209.GA10831@does.not.exist> <20080104034357.GA2113@atjola.homenet> <b4292e150801061349v3b54ffc0vfed75dbcb83daf9b@mail.gmail.com> <20080107014638.GA4170@atjola.homenet>
In-Reply-To: <20080107014638.GA4170@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink skrev:
> On 2008.01.06 19:49:49 -0200, Adolfo R. Brandes wrote:
>>  I have this forcedeth MAC address reversal problem when suspending
>> on 2 distinct boxes.  I can confirm Steinbrink's patch fixes the
>> problem on only one of them:
>>
>> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)
>>
>>  On the other one the problem persists:
>>
>> 00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)
> 
> Thanks. Leaves me pretty clueless though. Especially since it worked for
> Richard, who also has a MCP51. In a private mail, you said that you had
> hardcoded the mac address in the source. Any chance that you applied the
> patch on your modified sources and didn't get it right?
> 
> thanks,
> Björn
In case it matters, the revision of my device differs from Adolfo's:
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)

/ Richard
