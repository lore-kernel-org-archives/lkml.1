Return-Path: <linux-kernel-owner+w=401wt.eu-S1764737AbXESWhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764737AbXESWhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbXESWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:37:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:63611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbXESWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:36:59 -0400
Message-ID: <464F7C09.8060809@cv-sv.de>
Date: Sun, 20 May 2007 00:36:57 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Claas Langbehn <claas@rootdir.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: Via C3: other flags possible ?
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de> <464F332C.8060904@rootdir.de> <464F5C8F.5000304@cv-sv.de>
In-Reply-To: <464F5C8F.5000304@cv-sv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/lrbDyscW07KcZlx5f3RadTI2xrFdiJKBOjLC
 yHfykJkU68DmchXspD19xy7klhAY858hUPeCY/uKdku+vI4INK
 Cc+HqkXilHPOlOipE1zBw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Volkmann wrote:
> Hi,
> 
> Claas asked for the NX flag for the Via C3 (?) processors
> in another thread.
> 
> I do not know another synonym for this?
> 
> Claas Langbehn wrote:
>> Hello Christian,
>>
>> do you know if and how it's possible to enable NX_bit too?
>>
>>
>> Claas
>>
> 

C7 Esther:
Hmm, I expect the NX-Bit should be detected from linux during the
boot. The NX function bit seems to be at the same place where it's
located for other CPU.
Unfortunately I have no C7 hardware and I am too much a beginner
in kernel programming to prepare this "dry".

May be a "senior kernel programmer" can easy check if the C7 runs
through the regular NX-function detection?

Best regards,

Christian
