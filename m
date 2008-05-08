Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbYEHScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbYEHScR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbYEHSb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:31:58 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:39683 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbYEHSb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:31:57 -0400
Message-ID: <48234718.10604@isomerica.net>
Date: Thu, 08 May 2008 14:31:52 -0400
From: Dan Noe <dpn@isomerica.net>
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBFbHNkw7ZyZmVy?= <michael@elsdoerfer.info>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Cannot boot any HIGHMEM kernel (kernel panic - not syncing)
References: <4822DDF1.5010500@elsdoerfer.info> <87od7h9g1s.fsf@basil.nowhere.org> <4822EAC2.5010502@elsdoerfer.info>
In-Reply-To: <4822EAC2.5010502@elsdoerfer.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2008 07:57, Michael Elsdörfer wrote:
> So the problem would be defective RAM in the machine?

Especially with an MCE versus evidence of random bit flipping, I would 
also check to verify that all your memory modules are seated correctly. 
  If you are only using one of the DIMMs with LOWMEM only then you may 
be avoiding one which has a flakey connection.

I have solved at least one other mysterious MCE problem by reseating the 
DIMMS.

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Daniel Noe
                     |  http://isomerica.net/~dpn/

