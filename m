Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZHYTtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZHYTtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZHYTtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:49:06 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:58255 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbZHYTtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:49:05 -0400
Message-ID: <4A94402A.1090003@billgatliff.com>
Date: Tue, 25 Aug 2009 14:48:58 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
       linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org, linux-arm@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Nicolas Pitre <nico@cam.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: ARM subarch submissions for next merge window
References: <877hwtnxdx.fsf@deeprootsystems.com> <alpine.LFD.2.01.0908241249200.3158@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908241249200.3158@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 24 Aug 2009, Kevin Hilman wrote:
>   
>> After some discussions on linux-arm-kernel during the last merge
>> window, a suggestion from Alan Cox[1], and a willingness to try it
>> from Russell[2], some ARM subarch maintainers would like to push our
>> platform-specific code directly to you for the next merge window.
>>     

How do you define "subarch maintainer"?  If I have a new platform port, 
but am heretofore unknown to linux-arm-kernel, do I still send a pull 
request to Linus directly?  Or are the subarch maintainers the guys like 
Russell, Nico, Tony, etc. and _they_ are the ones that get to send pull 
requests directly to the Benevolent Dictator for Life?


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

