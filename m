Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYD2USh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYD2USh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbYD2USZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:18:25 -0400
Received: from gw.goop.org ([64.81.55.164]:47995 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760480AbYD2USY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:18:24 -0400
Message-ID: <48178283.4030208@goop.org>
Date: Tue, 29 Apr 2008 13:18:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Willy Tarreau <w@1wt.eu>, Helge Hafting <helge.hafting@aitel.hist.no>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429104216.GC19269@cs181133002.pp.htv.fi> <20080429110638.GG1473@1wt.eu> <20080429112718.GD19269@cs181133002.pp.htv.fi> <20080429113214.GE19269@cs181133002.pp.htv.fi>
In-Reply-To: <20080429113214.GE19269@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Apr 29, 2008 at 02:27:18PM +0300, Adrian Bunk wrote:
>   
>> You miss my point.
>>
>> The point is:
>> A conversion "ASCII -> UTF-8" is a nop.
>>
>> This means when changing the kernel from half a dozen charsets used in 
>> comments to UTF-8 we only had to change the few characters actually 
>> containing non UTF-8.
>>     
>
> "containing non-ASCII"
>   

Same thing ;)

    J
