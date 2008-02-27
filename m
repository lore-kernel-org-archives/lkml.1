Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbYB0WCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbYB0WCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbYB0WCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:02:31 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:52845 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbYB0WCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:02:30 -0500
Message-ID: <47C5DDE0.3040403@student.ltu.se>
Date: Wed, 27 Feb 2008 23:02:08 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: SL Baur <steve@xemacs.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jan Engelhardt <jengelh@computergmbh.de>, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
References: <1204062430.47c488def40a4@portal.student.luth.se>	<20080226135444.f83a0536.randy.dunlap@oracle.com>	<Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0802270033310.5714@axis700.grange>	<m31w6zcm4l.fsf@maximus.localdomain>	<ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com> <20080226213432.1388717b.randy.dunlap@oracle.com>
In-Reply-To: <20080226213432.1388717b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 26 Feb 2008 16:57:47 -0800 SL Baur wrote:
>
>   
>> On 2/26/08, Krzysztof Halasa <khc@pm.waw.pl> wrote:
>>
>>     
>>>  Hopefully an elisp expert will implement it. Vim people probably need
>>>  something like that as well, and the list of editors is a bit longer...
>>>       
>> The proposed two space change is ugly.  Can someone NAK it?
>>
>> -sb (The elisp guy who added the linux c-style)
>>     
>
> I would gladly NAK it, but most recent email from Linus about
> coding style is that we are getting too detailed about it,
> so unless there is some overwhelming need to change anything in
> CodingStyle, I'm for no changes (or maybe even some removals).
>
>   
Not sure if it can be counted as an overwhelming need, just actually 
defining the variable-wide character to be use "properly". Saw the way 
through CodeStyle as the correct way to get the "replace 8-space 
alignment to tab" nulled (then fix/change checkpatch.pl).

Actually, I see this as an quite simple question: is tab _the 
indention-marker_? If not, then why the refusal of spaces indents (or mix)?

