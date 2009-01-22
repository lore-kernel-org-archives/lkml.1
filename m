Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZAVAQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZAVAQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 19:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZAVAQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 19:16:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbZAVAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 19:16:35 -0500
Message-ID: <4977BAC2.3060009@zytor.com>
Date: Wed, 21 Jan 2009 16:16:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "H. Peter Anvin" <hpa@zytor.com>, kmh@nerdshack.com,
       linux-kernel@vger.kernel.org, lermen@elserv.ffm.fgan.de, lermen@fgan.de,
       davej@redhat.com, cebbert@redhat.com
Subject: Re: PROBLEM: loadlin incompatible with 2.6.23 kernels
References: <200712022336.SAA12095@granite.sover.net> <4977AB27.8080608@zytor.com> <20090121234347.GI5237@const.famille.thibault.fr>
In-Reply-To: <20090121234347.GI5237@const.famille.thibault.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
>>
>> Unfortunately LOADLIN hasn't been updated for a very long time, and 
>> there doesn't seem to be much interest in maintaining it.
> 
> I've fixed loadlin in debian and actually plan to maintain it upstream.
> I had to patch it quite a bit to make it compilable by yasm, but it can
> now boot recent big kernels & initrds.
> 

Excellent news!  Is there a new upstream location (or do you need one)?

	-hpa

