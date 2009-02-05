Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZBEUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZBEUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBEUjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:39:04 -0500
Received: from gw.goop.org ([64.81.55.164]:35778 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZBEUjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:39:03 -0500
Message-ID: <498B4E64.4090505@goop.org>
Date: Thu, 05 Feb 2009 12:39:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 36 of 36] x86: make the X_bad functions consistent
References: <patchbomb.1233862242@abulafia.goop.org> <d0b8ae3ef338132ad60d.1233862278@abulafia.goop.org> <Pine.LNX.4.64.0902052024470.13998@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902052024470.13998@blonde.anvils>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 5 Feb 2009, Jeremy Fitzhardinge wrote:
>
>   
>> Impact: cleanup
>>
>> Use the same logic to implement all 3 _bad() functions.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>     
>
> A backward step in my opinion.
>   

OK, I'm happy to go the other way.  I'll give it a spin.

    J
